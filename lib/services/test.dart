import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

class ChessDetectorService {
  late Interpreter _interpreter;
  final ImagePicker _picker = ImagePicker();
  
  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/best_train2_float32.tflite');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  Future<String> detectAndConvertToFen(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return '';

      final ProcessedImage processedImage = await _preprocessImage(image.path);
      final detections = await _runDetection(processedImage.pixels);
      
      // Tìm board trước
      final Detection? boardDetection = detections.firstWhere(
        (d) => d.classId == 7, // class_id cho board
        orElse: () => Detection(
          classId: -1,
          confidence: 0,
          box: Box(xCenter: 0, yCenter: 0, width: 0, height: 0),
        ),
      );

      if (boardDetection == null) {
        throw Exception('Không tìm thấy bàn cờ trong ảnh');
      }

      // Lọc các quân cờ nằm trong board
      final piecesInsideBoard = _filterPiecesInsideBoard(
        detections, 
        boardDetection,
        processedImage.originalSize,
        processedImage.padding
      );
      
      // Convert sang FEN
      final fen = _convertDetectionsToFen(piecesInsideBoard, boardDetection);
      
      return fen;
    } catch (e) {
      debugPrint('Error in detection: $e');
      return '';
    }
  }

  Future<ProcessedImage> _preprocessImage(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Tính padding để làm ảnh vuông
    final originalSize = Size(image.width.toDouble(), image.height.toDouble());
    final maxDim = math.max(image.width, image.height);
    final padding = ImagePadding(
      top: (maxDim - image.height) ~/ 2,
      bottom: maxDim - image.height - (maxDim - image.height) ~/ 2,
      left: (maxDim - image.width) ~/ 2,
      right: maxDim - image.width - (maxDim - image.width) ~/ 2,
    );

    // Tạo ảnh vuông với padding đen
    final paddedImage = img.copyResize(
      image,
      width: maxDim,
      height: maxDim,
      backgroundColor: img.ColorRgb8(0, 0, 0),
    );

    // Resize về 640x640
    final resized = img.copyResize(paddedImage, width: 640, height: 640);
    
    // Normalize pixel values
    List<double> normalizedPixels = [];
    for (var pixel in resized.getBytes()) {
      normalizedPixels.add(pixel / 255.0);
    }

    return ProcessedImage(
      pixels: normalizedPixels,
      originalSize: originalSize,
      padding: padding,
    );
  }

  List<Detection> _filterPiecesInsideBoard(
    List<Detection> detections,
    Detection board,
    Size originalSize,
    ImagePadding padding,
  ) {
    // Chuyển đổi tọa độ board về không gian ảnh gốc
    final boardBox = _convertToOriginalCoordinates(
      board.box,
      originalSize,
      padding,
    );

    // Lọc các quân cờ
    return detections.where((detection) {
      // Bỏ qua board
      if (detection.classId == 7) return false;

      // Chuyển tọa độ quân cờ về không gian ảnh gốc
      final pieceBox = _convertToOriginalCoordinates(
        detection.box,
        originalSize,
        padding,
      );

      // Kiểm tra quân cờ có nằm trong board không
      return _isBoxInsideBoard(pieceBox, boardBox);
    }).toList();
  }

  Box _convertToOriginalCoordinates(Box normalizedBox, Size originalSize, ImagePadding padding) {
    final maxDim = math.max(originalSize.width, originalSize.height);
    
    // Chuyển từ tọa độ normalized (0-1) sang tọa độ 640x640
    final x640 = normalizedBox.xCenter * 640;
    final y640 = normalizedBox.yCenter * 640;
    final w640 = normalizedBox.width * 640;
    final h640 = normalizedBox.height * 640;

    // Chuyển từ 640x640 sang tọa độ ảnh đã pad
    final xPadded = (x640 * maxDim) / 640;
    final yPadded = (y640 * maxDim) / 640;
    final wPadded = (w640 * maxDim) / 640;
    final hPadded = (h640 * maxDim) / 640;

    // Chuyển từ tọa độ đã pad sang tọa độ ảnh gốc
    return Box(
      xCenter: xPadded - padding.left,
      yCenter: yPadded - padding.top,
      width: wPadded,
      height: hPadded,
    );
  }

  bool _isBoxInsideBoard(Box piece, Box board) {
    final boardLeft = board.xCenter - board.width / 2;
    final boardRight = board.xCenter + board.width / 2;
    final boardTop = board.yCenter - board.height / 2;
    final boardBottom = board.yCenter + board.height / 2;

    final pieceLeft = piece.xCenter - piece.width / 2;
    final pieceRight = piece.xCenter + piece.width / 2;
    final pieceTop = piece.yCenter - piece.height / 2;
    final pieceBottom = piece.yCenter + piece.height / 2;

    // Kiểm tra center point của quân cờ có nằm trong board
    return piece.xCenter >= boardLeft &&
           piece.xCenter <= boardRight &&
           piece.yCenter >= boardTop &&
           piece.yCenter <= boardBottom;
  }

  String _convertDetectionsToFen(List<Detection> pieces, Detection board) {
    // Khởi tạo bàn cờ trống
    List<List<String>> boardArray = List.generate(10, (_) => List.filled(9, ''));
    
    // Với mỗi quân cờ, tính toán vị trí tương đối so với board
    for (var piece in pieces) {
      final position = _calculateBoardPosition(piece.box, board.box);
      if (position != null) {
        final pieceSymbol = _mapClassToPiece(piece.classId);
        boardArray[position.rank][position.file] = pieceSymbol;
      }
    }
    
    return _boardToFen(boardArray);
  }

Future<List<Detection>> _runDetection(List<double> processedImage) async {
  try {
    // Prepare input tensor
    var inputShape = [1, 640, 640, 3];
    var inputArray = Float32List.fromList(processedImage);

    // Prepare output tensor - shape như trong Python [1, 8400, 19]
    var outputShape = [1, 8400, 19];
    var outputArray = Float32List(outputShape[0] * outputShape[1] * outputShape[2]);

    // Run inference
    _interpreter.run(inputArray, outputArray);

    // Process outputs
    return _processOutputs(outputArray, outputShape);
  } catch (e) {
    debugPrint('Error running detection: $e');
    rethrow;
  }
}

List<Detection> _processOutputs(Float32List outputs, List<int> outputShape) {
  List<Detection> detections = [];
  double confidenceThreshold = 0.5;
  double iouThreshold = 0.5;

  // Chuyển đổi mảng 1 chiều thành mảng 3 chiều [1, 8400, 19]
  var predictions = List.generate(
    outputShape[1],
    (i) => List.generate(
      outputShape[2],
      (j) => outputs[i * outputShape[2] + j],
    ),
  );

  // Với mỗi detection
  for (int i = 0; i < outputShape[1]; i++) {
    // Lấy scores cho mỗi class (4 đến 19)
    var scores = predictions[i].sublist(4);
    var maxScore = 0.0;
    var classId = -1;

    // Tìm class có score cao nhất
    for (int j = 0; j < scores.length; j++) {
      if (scores[j] > maxScore) {
        maxScore = scores[j];
        classId = j;
      }
    }

    // Nếu confidence vượt ngưỡng
    if (maxScore > confidenceThreshold) {
      // Lấy box coordinates
      var x = predictions[i][0];
      var y = predictions[i][1];
      var w = predictions[i][2];
      var h = predictions[i][3];

      detections.add(Detection(
        classId: classId,
        confidence: maxScore,
        box: Box(
          xCenter: x,
          yCenter: y,
          width: w,
          height: h,
        ),
      ));
    }
  }

  // Apply NMS
  detections = _applyNMS(detections, iouThreshold);

  return detections;
}


List<Detection> _applyNMS(List<Detection> detections, double iouThreshold) {
  // Sort by confidence
  detections.sort((a, b) => b.confidence.compareTo(a.confidence));
  
  List<Detection> selected = [];
  List<bool> suppressed = List.filled(detections.length, false);

  for (int i = 0; i < detections.length; i++) {
    if (suppressed[i]) continue;

    selected.add(detections[i]);

    for (int j = i + 1; j < detections.length; j++) {
      if (suppressed[j]) continue;

      if (_calculateIoU(detections[i].box, detections[j].box) > iouThreshold) {
        suppressed[j] = true;
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

  // Calculate intersection area
  double intersectionX1 = math.max(box1X1, box2X1);
  double intersectionY1 = math.max(box1Y1, box2Y1);
  double intersectionX2 = math.min(box1X2, box2X2);
  double intersectionY2 = math.min(box1Y2, box2Y2);

  if (intersectionX2 <= intersectionX1 || intersectionY2 <= intersectionY1) {
    return 0.0;
  }

  double intersectionArea = (intersectionX2 - intersectionX1) *
      (intersectionY2 - intersectionY1);

  // Calculate union area
  double box1Area = (box1X2 - box1X1) * (box1Y2 - box1Y1);
  double box2Area = (box2X2 - box2X1) * (box2Y2 - box2Y1);
  double unionArea = box1Area + box2Area - intersectionArea;

  return intersectionArea / unionArea;
}

String _boardToFen(List<List<String>> board) {
  List<String> rankStrings = [];

  // Duyệt qua từng hàng của bàn cờ
  for (var rank in board) {
    String currentRank = '';
    int emptyCount = 0;

    // Xử lý từng ô trong hàng
    for (var piece in rank) {
      if (piece.isEmpty) {
        emptyCount++;
      } else {
        // Nếu có quân cờ đếm số ô trống trước đó
        if (emptyCount > 0) {
          currentRank += emptyCount.toString();
          emptyCount = 0;
        }
        currentRank += piece;
      }
    }

    // Xử lý ô trống cuối hàng nếu có
    if (emptyCount > 0) {
      currentRank += emptyCount.toString();
    }

    rankStrings.add(currentRank);
  }

  // Nối các hàng lại với nhau bằng dấu '/'
  return rankStrings.join('/');
}

  Position? _calculateBoardPosition(Box pieceBox, Box boardBox) {
    // Tính toán vị trí tương đối của quân cờ trong board
    final relativeX = (pieceBox.xCenter - (boardBox.xCenter - boardBox.width/2)) / boardBox.width;
    final relativeY = (pieceBox.yCenter - (boardBox.yCenter - boardBox.height/2)) / boardBox.height;
    
    // Chuyển đổi thành vị trí trên bàn cờ (9x10)
    final file = (relativeX * 9).round();
    final rank = (relativeY * 10).round();
    
    // Kiểm tra vị trí có hợp lệ không
    if (file >= 0 && file < 9 && rank >= 0 && rank < 10) {
      return Position(rank: rank, file: file);
    }
    return null;
  }

  String _mapClassToPiece(int classId) {
    // Map class IDs to piece symbols
    final Map<int, String> pieceMap = {
      0: 'p', // b_bing
      1: 'r', // b_che
      2: 'k', // b_jiang
      3: 'n', // b_ma
      4: 'c', // b_pao
      5: 'a', // b_shi
      6: 'b', // b_xiang
      8: 'P', // r_bing
      9: 'R', // r_che
      10: 'K', // r_jiang
      11: 'N', // r_ma
      12: 'C', // r_pao
      13: 'A', // r_shi
      14: 'B', // r_xiang
    };
    return pieceMap[classId] ?? '';
  }
  
 
}

// Supporting classes
class ProcessedImage {
  final List<double> pixels;
  final Size originalSize;
  final ImagePadding padding;

  ProcessedImage({
    required this.pixels,
    required this.originalSize,
    required this.padding,
  });
}

class ImagePadding {
  final int top;
  final int bottom;
  final int left;
  final int right;

  ImagePadding({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
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