import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class ChessDetectorService {
  late Interpreter _interpreter;
  final ImagePicker _picker = ImagePicker();

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/best_train2_float32.tflite'
      );

      final inputShape = _interpreter.getInputTensor(0).shape;
      final outputShape = _interpreter.getOutputTensor(0).shape;
      debugPrint('Input Shape: $inputShape');
      debugPrint('Output Shape: $outputShape');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  Future<String> detectAndConvertToFen(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: null,
        maxWidth: null,
      );
      if (image == null) return '';

      final processedImage = await _preprocessImage(image.path);
      final detections = await _runDetection(processedImage);
      final fen = _convertDetectionsToFen(detections);

      return fen;
    } catch (e) {
      debugPrint('Error in detection: $e');
      return '';
    }
  }

  Future<Float32List> _preprocessImage(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Convert to RGB if needed
    if (image.numChannels != 3) {
      image = image.convert(numChannels: 3);
    }

    // Create square padded image
    final maxDim = math.max(image.width, image.height);
    final paddedImage = img.Image(width: maxDim, height: maxDim);
    img.fill(paddedImage, color: img.ColorRgb8(0, 0, 0));

    // Center the original image
    final xOffset = (maxDim - image.width) ~/ 2;
    final yOffset = (maxDim - image.height) ~/ 2;
    img.compositeImage(paddedImage, image, dstX: xOffset, dstY: yOffset);

    // Resize to 640x640
    var resized = img.copyResize(paddedImage, width: 640, height: 640);

    // Create input tensor [1, 640, 640, 3]
    var inputBuffer = Float32List(1 * 640 * 640 * 3);
    var idx = 0;

    // Fill the input buffer in NHWC format (batch, height, width, channels)
    for (var y = 0; y < 640; y++) {
      for (var x = 0; x < 640; x++) {
        final pixel = resized.getPixel(x, y);
        inputBuffer[idx++] = pixel.r / 255.0;
        inputBuffer[idx++] = pixel.g / 255.0;
        inputBuffer[idx++] = pixel.b / 255.0;
      }
    }

    debugPrint('Preprocessed image shape: [1, 640, 640, 3]');
    debugPrint('First few values: ${inputBuffer.take(10).toList()}');

    return inputBuffer;
  }

  Future<List<Detection>> _runDetection(Float32List processedImage) async {
    try {
      // Input shape should be [1, 640, 640, 3]
      final inputShape = [1, 640, 640, 3];

      // Create properly shaped output tensor [1, 19, 8400]
      final outputTensor = [
        List<List<double>>.filled(
          19,
          List<double>.filled(8400, 0.0),
          growable: false,
        )
      ];

      // Run inference with properly shaped tensors
      _interpreter.run(
        processedImage.reshape(inputShape),
        outputTensor,
      );

      // Convert the nested list output to Float32List for processing
      final outputList = Float32List(19 * 8400);
      var idx = 0;
      for (var i = 0; i < 19; i++) {
        for (var j = 0; j < 8400; j++) {
          outputList[idx++] = outputTensor[0][i][j];
        }
      }

      // Debug output
      debugPrint('Output first few values:');
      for (var i = 0; i < math.min(20, outputList.length); i++) {
        debugPrint('$i: ${outputList[i]}');
      }

      // Process the output
      return _processOutputs(outputList);
    } catch (e) {
      debugPrint('Error in detection: $e');
      rethrow;
    }
  }

  List<Detection> _processOutputs(Float32List outputs) {
    List<Detection> detections = [];
    final confidenceThreshold = 0.25;
    final numBoxes = 8400;
    final numClasses = 15;
    final numValues = 4 + numClasses; // 4 box coords + 15 classes

    for (var i = 0; i < numBoxes; i++) {
      // For YOLOv8 output format [8400, 19]
      // First 4 values are box coordinates
      final xCenter = outputs[i];
      final yCenter = outputs[i + numBoxes];
      final width = outputs[i + 2 * numBoxes];
      final height = outputs[i + 3 * numBoxes];

      // Next 15 values are class scores
      var maxScore = 0.0;
      var maxClassId = -1;
      for (var c = 0; c < numClasses; c++) {
        final score = outputs[i + (4 + c) * numBoxes];
        if (score > maxScore) {
          maxScore = score;
          maxClassId = c;
        }
      }

      if (maxScore > confidenceThreshold) {
        detections.add(Detection(
          classId: maxClassId,
          confidence: maxScore,
          box: Box(
            xCenter: xCenter,
            yCenter: yCenter,
            width: width,
            height: height,
          ),
        ));
      }
    }

    debugPrint('Total detections before NMS: ${detections.length}');
    final nmsResults = _applyNMS(detections, 0.5);
    debugPrint('Total detections after NMS: ${nmsResults.length}');

    return nmsResults;
  }

  Float32List _transposeOutput(Float32List output) {
    final inputShape = [1, 19, 8400];
    final outputShape = [1, 8400, 19];
    final transposed = Float32List(output.length);

    for (var n = 0; n < inputShape[0]; n++) {
      for (var h = 0; h < inputShape[1]; h++) {
        for (var w = 0; w < inputShape[2]; w++) {
          // Source index in [1, 19, 8400] format
          final srcIdx =
              n * (inputShape[1] * inputShape[2]) + h * inputShape[2] + w;

          // Destination index in [1, 8400, 19] format
          final dstIdx =
              n * (outputShape[1] * outputShape[2]) + w * outputShape[2] + h;

          transposed[dstIdx] = output[srcIdx];
        }
      }
    }

    return transposed;
  }

  List<Detection> _applyNMS(List<Detection> detections, double iouThreshold) {
    // Sort by confidence
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));

    List<Detection> selected = [];
    Set<int> suppressed = {};

    for (var i = 0; i < detections.length; i++) {
      if (suppressed.contains(i)) continue;

      selected.add(detections[i]);

      for (var j = i + 1; j < detections.length; j++) {
        if (suppressed.contains(j)) continue;

        if (_calculateIoU(detections[i].box, detections[j].box) >=
            iouThreshold) {
          suppressed.add(j);
        }
      }
    }

    return selected;
  }

  double _calculateIoU(Box box1, Box box2) {
    // Convert center format to corners
    double box1X1 = box1.xCenter - box1.width / 2;
    double box1Y1 = box1.yCenter - box1.height / 2;
    double box1X2 = box1.xCenter + box1.width / 2;
    double box1Y2 = box1.yCenter + box1.height / 2;

    double box2X1 = box2.xCenter - box2.width / 2;
    double box2Y1 = box2.yCenter - box2.height / 2;
    double box2X2 = box2.xCenter + box2.width / 2;
    double box2Y2 = box2.yCenter + box2.height / 2;

    // Calculate intersection
    double intersectX1 = math.max(box1X1, box2X1);
    double intersectY1 = math.max(box1Y1, box2Y1);
    double intersectX2 = math.min(box1X2, box2X2);
    double intersectY2 = math.min(box1Y2, box2Y2);

    double intersectArea = math.max(0, intersectX2 - intersectX1) *
        math.max(0, intersectY2 - intersectY1);

    // Calculate union
    double box1Area = box1.width * box1.height;
    double box2Area = box2.width * box2.height;
    double unionArea = box1Area + box2Area - intersectArea;

    return intersectArea / unionArea;
  }

  Position _mapBoxToPosition(Box box) {
    // Clamp values to ensure they're within [0,1]
    final clampedX = box.xCenter.clamp(0.0, 1.0);
    final clampedY = box.yCenter.clamp(0.0, 1.0);

    // Map to board coordinates (0-8 for files, 0-9 for ranks)
    // Subtract small epsilon to avoid edge case where value of 1.0 causes overflow
    final file = (clampedX * 9 - 0.001).floor();
    final rank = (clampedY * 10 - 0.001).floor();

    debugPrint(
        'Mapping box (${box.xCenter}, ${box.yCenter}) -> (rank: $rank, file: $file)');
    return Position(rank: rank, file: file);
  }

String _convertDetectionsToFen(List<Detection> detections) {
  // Tìm bounding box của bàn cờ và các quân cờ
  Detection? boardDetection;
  List<Detection> pieceDetections = [];
  
  for (var detection in detections) {
    if (_mapClassToPieceOrBoard(detection.classId) == 'board') {
      boardDetection = detection;
    } else {
      pieceDetections.add(detection);
    }
  }
  
  if (boardDetection == null) {
    return '';
  }

  // Khởi tạo bàn cờ trống 10x9
  List<List<String>> board = List.generate(10, (_) => List.filled(9, ''));
  
  // Tính toán biên của bàn cờ
  double boardLeft = boardDetection.box.xCenter - boardDetection.box.width/2;
  double boardRight = boardDetection.box.xCenter + boardDetection.box.width/2;
  double boardTop = boardDetection.box.yCenter - boardDetection.box.height/2;
  double boardBottom = boardDetection.box.yCenter + boardDetection.box.height/2;
  
  // Tính toán tọa độ tương đối cho mỗi quân cờ
  for (var piece in pieceDetections) {
    // Tính biên của quân cờ
    double pieceLeft = piece.box.xCenter - piece.box.width/2;
    double pieceRight = piece.box.xCenter + piece.box.width/2;
    double pieceTop = piece.box.yCenter - piece.box.height/2;
    double pieceBottom = piece.box.yCenter + piece.box.height/2;
    
    // Kiểm tra xem quân cờ có giao với bàn cờ không
    bool hasIntersection = !(
      pieceLeft > boardRight ||    // Quân nằm hoàn toàn bên phải bàn cờ
      pieceRight < boardLeft ||    // Quân nằm hoàn toàn bên trái bàn cờ
      pieceTop > boardBottom ||    // Quân nằm hoàn toàn bên dưới bàn cờ
      pieceBottom < boardTop       // Quân nằm hoàn toàn bên trên bàn cờ
    );
    
    if (!hasIntersection) {
      debugPrint('Loại bỏ quân cờ hoàn toàn nằm ngoài bàn: ${_mapClassToPieceOrBoard(piece.classId)}');
      continue; // Bỏ qua quân cờ này
    }
    
    // Tính toán vị trí tương đối so với bàn cờ
    double relativeX = (piece.box.xCenter - boardLeft) / boardDetection.box.width;
    double relativeY = (piece.box.yCenter - boardTop) / boardDetection.box.height;
    
    // Đảm bảo giá trị nằm trong khoảng [0,1]
    relativeX = relativeX.clamp(0.0, 0.999);
    relativeY = relativeY.clamp(0.0, 0.999);
    
    // Chuyển đổi sang tọa độ bàn cờ (9x10)
    int file = (relativeX * 9).floor(); // 0-8 cho file (cột)
    int rank = (relativeY * 10).floor(); // 0-9 cho rank (hàng)
    
    String pieceType = _mapClassToPieceOrBoard(piece.classId);
    bool isRedPiece = pieceType == pieceType.toUpperCase(); // Quân đỏ là chữ in hoa
    
        
    // Kiểm tra lại một lần nữa xem vị trí có hợp lệ không
    if (file < 0 || file > 8 || rank < 0 || rank > 9) {
      debugPrint('Loại bỏ quân cờ có vị trí không hợp lệ: file=$file, rank=$rank');
      continue;
    }
    
    if (pieceType.isNotEmpty && pieceType != 'board') {
      // Logic xử lý trùng vị trí - chọn quân có confidence cao hơn
      if (board[rank][file].isEmpty || piece.confidence > (confidenceMap[board[rank][file]] ?? 0.0)) {
        if (!board[rank][file].isEmpty) {
          debugPrint('Thay thế quân ${board[rank][file]} bằng quân $pieceType tại rank=$rank, file=$file (confidence cao hơn)');
        }
        board[rank][file] = pieceType;
        confidenceMap[pieceType] = piece.confidence;
        debugPrint('Đặt quân $pieceType tại rank=$rank, file=$file');
      } else {
        debugPrint('Giữ nguyên quân ${board[rank][file]} tại rank=$rank, file=$file');
      }
    }
  }

  return _boardToFen(board);
}

// Map để lưu confidence của các quân cờ đã đặt
Map<String, double> confidenceMap = {};

  String _boardToFen(List<List<String>> board) {
    List<String> ranks = [];
    for (var rank in board) {
      String rankStr = '';
      int emptyCount = 0;

      for (var piece in rank) {
        if (piece.isEmpty) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            rankStr += emptyCount.toString();
            emptyCount = 0;
          }
          rankStr += piece;
        }
      }

      if (emptyCount > 0) {
        rankStr += emptyCount.toString();
      }

      ranks.add(rankStr);
    }

    final fen = ranks.join('/');
    debugPrint('Generated FEN: $fen');
    return fen;
  }

  String _mapClassToPieceOrBoard(int classId) {
    final Map<int, String> pieceMap = {
      0: 'p', // black pawn
      1: 'r', // black rook
      2: 'k', // black king
      3: 'n', // black knight
      4: 'c', // black cannon
      5: 'a', // black advisor
      6: 'b', // black bishop
      7: 'board', // board
      8: 'P', // red pawn
      9: 'R', // red rook
      10: 'K', // red king
      11: 'N', // red knight
      12: 'C', // red cannon
      13: 'A', // red advisor
      14: 'B', // red bishop
    };

    final piece = pieceMap[classId] ?? '';
    debugPrint('Mapping class $classId to piece: $piece');
    return piece;
  }
}

class Detection {
  final int classId;
  final double confidence;
  final Box box;

  Detection({
    required this.classId,
    required this.confidence,
    required this.box,
  });
}

class Box {
  final double xCenter;
  final double yCenter;
  final double width;
  final double height;

  Box({
    required this.xCenter,
    required this.yCenter,
    required this.width,
    required this.height,
  });
}

class Position {
  final int rank;
  final int file;

  Position({required this.rank, required this.file});
}
