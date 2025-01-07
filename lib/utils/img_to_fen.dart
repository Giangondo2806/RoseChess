import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class XiangqiDetector {
  late Interpreter _interpreter;
  // --- Configuration ---
  final String modelPath = 'assets/best_train2_float32.tflite';
  final double confThreshold = 0.5;
  final double iouThreshold = 0.5;

  // --- Class names ---
  final Map<int, String> classNames = {
    0: 'b_bing',
    1: 'b_che',
    2: 'b_jiang',
    3: 'b_ma',
    4: 'b_pao',
    5: 'b_shi',
    6: 'b_xiang',
    7: 'board',
    8: 'r_bing',
    9: 'r_che',
    10: 'r_jiang',
    11: 'r_ma',
    12: 'r_pao',
    13: 'r_shi',
    14: 'r_xiang'
  };

  XiangqiDetector() {
    _loadModel();
  }

  // --- Load TFLite model ---
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print('Interpreter loaded successfully');
      // Get input and output details
      var inputDetails = _interpreter.getInputTensor(0);
      var outputDetails = _interpreter.getOutputTensor(0);
      print("Input Details: $inputDetails");
      print("Output Details: $outputDetails");
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  // --- Preprocess image ---
  Future<(img.Image, int, int, img.Image, int, int, int)> preprocess(
      img.Image image) async {
    img.Image originalImage = image.clone();
    int imageHeight = image.height;
    int imageWidth = image.width;

    // Add padding to make the image square
    int maxDim = max(imageHeight, imageWidth);
    int top = (maxDim - imageHeight) ~/ 2;
    int bottom = maxDim - imageHeight - top;
    int left = (maxDim - imageWidth) ~/ 2;
    int right = maxDim - imageWidth - left;

    var blankImage = img.Image(width: maxDim, height: maxDim);
    img.Image paddedImage = img.copyResize(
      img.compositeImage(blankImage, image, dstX: left, dstY: top),
      width: 640,
      height: 640,
    );

    // Normalize and convert to float32 list
    List<double> input = [];
    for (int y = 0; y < 640; y++) {
      for (int x = 0; x < 640; x++) {
        img.Pixel pixel = paddedImage.getPixel(x, y);
        input.add(pixel.r.toDouble() / 255.0);
        input.add(pixel.g.toDouble() / 255.0);
        input.add(pixel.b.toDouble() / 255.0);
      }
    }

    // Reshape to 1x640x640x3
    var inputImage = Float32List.fromList(input).reshape([1, 640, 640, 3]);
    Float32List flatInputImage = inputImage[0];
    return (
      img.Image.fromBytes(
          width: 640,
          height: 640,
          bytes: flatInputImage.buffer.asUint8List().buffer,
          numChannels: 3),
      imageHeight,
      imageWidth,
      originalImage,
      maxDim,
      top,
      left
    );
  }

  // --- Detect objects ---
  List<dynamic> detect(List<List<List<List<double>>>> inputData) {
    // Define output shape based on your model
    // Assuming your model outputs a 1x19x8400 array
    // Adjust the shape according to your model's output
    List<List<double>> output =
        List.generate(19, (i) => List.filled(8400, 0.0));
    List<List<List<double>>> outputList = [output];
    // Run inference
    _interpreter.run(inputData, outputList);
    print("Raw output shape: ${outputList[0].shape}");

    return outputList[0];
  }

  // --- Postprocess results ---
  (List<List<double>>, List<double>, List<int>) postprocessYolov8(
      List<dynamic> output, double confThreshold, double iouThreshold) {
    // Transpose output to 8400x19
    List<List<double>> predictions =
        List.generate(output[0].length, (i) => List.filled(output.length, 0.0));
    for (int i = 0; i < output.length; i++) {
      for (int j = 0; j < output[0].length; j++) {
        predictions[j][i] = output[i][j];
      }
    }
    print("Transposed predictions shape: ${predictions.shape}");

    // Get scores, boxes, and class IDs
    List<double> scores = [];
    List<List<double>> boxes = [];
    List<int> classIds = [];

    for (int i = 0; i < predictions.length; i++) {
      double maxScore = 0;
      int classId = -1;
      for (int j = 4; j < predictions[0].length; j++) {
        if (predictions[i][j] > maxScore) {
          maxScore = predictions[i][j];
          classId = j - 4;
        }
      }
      if (maxScore > confThreshold) {
        scores.add(maxScore);
        boxes.add(predictions[i].sublist(0, 4));
        classIds.add(classId);
      }
    }

    print("Filtered predictions: ${boxes.length}");
    print("Unique class IDs: ${classIds.toSet()}");

    // Convert boxes from center_x, center_y, w, h to x1, y1, x2, y2
    List<List<double>> boxesXyxy = [];
    for (var box in boxes) {
      double xCenter = box[0];
      double yCenter = box[1];
      double width = box[2];
      double height = box[3];

      double x1 = xCenter - width / 2;
      double y1 = yCenter - height / 2;
      double x2 = xCenter + width / 2;
      double y2 = yCenter + height / 2;

      boxesXyxy.add([x1, y1, x2, y2]);
    }

    // Apply Non-Maximum Suppression (NMS) - you might need to implement this yourself or find a library
    List<int> indices = _nonMaxSuppression(boxesXyxy, scores, iouThreshold);

    List<List<double>> finalBoxes = [];
    List<double> finalConfidences = [];
    List<int> finalClassIds = [];

    if (indices.isNotEmpty) {
      for (var index in indices) {
        finalBoxes.add(boxesXyxy[index]);
        finalConfidences.add(scores[index]);
        finalClassIds.add(classIds[index]);
      }
    }

    return (finalBoxes, finalConfidences, finalClassIds);
  }

  // Simple NMS (Non-Maximum Suppression) - you may need a more robust implementation
  List<int> _nonMaxSuppression(
      List<List<double>> boxes, List<double> scores, double iouThreshold) {
    if (boxes.isEmpty) return [];

    List<int> indices = List.generate(scores.length, (i) => i);
    indices.sort((a, b) => scores[b].compareTo(scores[a]));

    List<int> keep = [];
    while (indices.isNotEmpty) {
      int i = indices.removeAt(0);
      keep.add(i);

      indices.removeWhere((j) {
        double xx1 = max(boxes[i][0], boxes[j][0]);
        double yy1 = max(boxes[i][1], boxes[j][1]);
        double xx2 = min(boxes[i][2], boxes[j][2]);
        double yy2 = min(boxes[i][3], boxes[j][3]);

        double w = max(0.0, xx2 - xx1);
        double h = max(0.0, yy2 - yy1);

        double inter = w * h;
        double iou = inter /
            ((boxes[i][2] - boxes[i][0]) * (boxes[i][3] - boxes[i][1]) +
                (boxes[j][2] - boxes[j][0]) * (boxes[j][3] - boxes[j][1]) -
                inter);

        return iou > iouThreshold;
      });
    }

    return keep;
  }

  // --- Convert detections to FEN ---
  String convertToFen(List<List<double>> boxes, List<int> classIds,
      int boardWidth, int boardHeight) {
    // 1. Initialize an empty board representation (e.g., a 2D list or a string)
    List<List<String>> board = List.generate(10, (_) => List.filled(9, ''));

    // 2. Map detected pieces to their positions on the board based on coordinates and class IDs.
    for (int i = 0; i < boxes.length; i++) {
      int classId = classIds[i];
      String piece = _getFenPiece(classId); // Implement _getFenPiece

      // Assuming you have the center coordinates of the detected piece
      double centerX = (boxes[i][0] + boxes[i][2]) / 2;
      double centerY = (boxes[i][1] + boxes[i][3]) / 2;

      // Map to board coordinates (assuming 9x10 board)
      int col = (centerX * 9 ~/ 640); // Convert from 640 to 9 cols
      int row = (centerY * 10 ~/ 640); // Convert from 640 to 10 rows

      // Adjust for board boundaries
      col = max(0, min(col, 8));
      row = max(0, min(row, 9));

      // Place the piece on the board
      board[row][col] = piece;
    }

    // 3. Convert the board representation to FEN.
    String fen = '';
    for (int row = 0; row < 10; row++) {
      int emptyCount = 0;
      for (int col = 0; col < 9; col++) {
        if (board[row][col].isEmpty) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            fen += emptyCount.toString();
            emptyCount = 0;
          }
          fen += board[row][col];
        }
      }
      if (emptyCount > 0) {
        fen += emptyCount.toString();
      }
      if (row < 9) {
        fen += '/';
      }
    }

    // 4. Add side to move, castling availability, en passant target square, halfmove clock, and fullmove number (you'll need to manage these separately).
    fen += ' w - - 0 1'; // Replace with actual values

    return fen;
  }

  // --- Helper function to get FEN piece representation ---
  String _getFenPiece(int classId) {
    // Convert class ID to FEN notation
    switch (classId) {
      case 0:
        return 'p'; // Black pawn (b_bing)
      case 1:
        return 'r'; // Black chariot (b_che)
      case 2:
        return 'k'; // Black general (b_jiang)
      case 3:
        return 'n'; // Black horse (b_ma)
      case 4:
        return 'c'; // Black cannon (b_pao)
      case 5:
        return 'a'; // Black advisor (b_shi)
      case 6:
        return 'b'; // Black elephant (b_xiang)
      case 8:
        return 'P'; // Red pawn (r_bing)
      case 9:
        return 'r'; // Red chariot (r_che)
      case 10:
        return 'K'; // Red general (r_jiang)
      case 11:
        return 'N'; // Red horse (r_ma)
      case 12:
        return 'C'; // Red cannon (r_pao)
      case 13:
        return 'A'; // Red advisor (r_shi)
      case 14:
        return 'B'; // Red elephant (r_xiang)
      case 7:
        return 'board'; // Unknown or board
      default:
        return '';
    }
  }
}
