// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// img.Image preprocessImage(File imageFile) {
//   List<int> imageBytes = imageFile.readAsBytesSync();
//   img.Image? originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
  
//   if (originalImage == null) {
//     throw Exception('Không thể đọc được ảnh');
//   }

//   int targetWidth = 640;
//   int targetHeight = 640;

//   // Tạo một ảnh nền đen với kích thước mong muốn
//   img.Image resizedImage = img.Image(
//     width: targetWidth,
//     height: targetHeight,
//     format: img.Format.uint8,
//   );
  
//   // Tô màu đen cho nền
//   img.fill(resizedImage, color: img.ColorRgba8(0, 0, 0, 255));

//   // Tính toán tỷ lệ scale để giữ nguyên tỷ lệ ảnh
//   double scale = 1.0;
//   if (originalImage.width > originalImage.height) {
//     scale = targetWidth / originalImage.width;
//   } else {
//     scale = targetHeight / originalImage.height;
//   }

//   // Tính kích thước mới sau khi scale
//   int newWidth = (originalImage.width * scale).round();
//   int newHeight = (originalImage.height * scale).round();

//   // Resize ảnh gốc giữ nguyên tỷ lệ
//   img.Image scaledImage = img.copyResize(
//     originalImage,
//     width: newWidth,
//     height: newHeight,
//     interpolation: img.Interpolation.linear
//   );

//   // Tính toán vị trí để căn giữa
//   int x = (targetWidth - newWidth) ~/ 2;
//   int y = (targetHeight - newHeight) ~/ 2;

//   // Copy ảnh đã scale vào ảnh nền
//   img.compositeImage(resizedImage, scaledImage, dstX: x, dstY: y, blend: img.BlendMode.alpha);

//   return resizedImage;
// }




import 'dart:io';
import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ChessPosition {
  final String piece;
  final double x;
  final double y;
  
  ChessPosition(this.piece, this.x, this.y);
}

class ChessDetector {
  late Interpreter _interpreter;
  
  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/models/best_train2.tflite');
  }

  // Chuyển đổi piece code thành ký tự FEN
  String _pieceToFen(String piece) {
    final Map<String, String> pieceToFen = {
      'r_che': 'r', 'r_ma': 'n', 'r_xiang': 'b',
      'r_shi': 'a', 'r_jiang': 'k', 'r_pao': 'c',
      'r_bing': 'p', 'b_che': 'R', 'b_ma': 'N',
      'b_xiang': 'B', 'b_shi': 'A', 'b_jiang': 'K',
      'b_pao': 'C', 'b_bing': 'P',
    };
    return pieceToFen[piece] ?? '';
  }

  Future<List<ChessPosition>> detectPieces(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes())!;
    
    // Tìm bàn cờ và transform
    final boardCorners = detectBoardCorners(image);
    final transformedImage = perspectiveTransform(image, boardCorners);
    
    // Xử lý và padding ảnh
    final processedImage = _preprocessImage(transformedImage);
    
    // Thực hiện inference
    final output = List<List<List<double>>>.filled(
      1, List<List<double>>.filled(19, List<double>.filled(8400, 0)));
    
    _interpreter.run(processedImage, output);
    
    // Xử lý output và transform ngược vị trí
    final positions = _postprocessYolov11(output[0]);
    return _transformPositions(positions, boardCorners);
  }

  List<Point<int>> detectBoardCorners(img.Image image) {
    // TODO: Implement board corner detection
    // Có thể dùng các kỹ thuật như:
    // 1. Edge detection (Canny)
    // 2. Line detection (Hough Transform)
    // 3. Corner detection (Harris corner)
    // 4. Contour detection và tìm contour lớn nhất có 4 góc
    
    // Tạm thời trả về góc mặc định
    return [
      Point(0, 0),
      Point(image.width, 0),
      Point(image.width, image.height),
      Point(0, image.height),
    ];
  }

  img.Image perspectiveTransform(img.Image image, List<Point<int>> corners) {
    // TODO: Implement perspective transform
    // Chuyển đổi hình ảnh nghiêng thành hình vuông
    // Có thể dùng homography matrix để transform
    
    return image; // Tạm thời trả về ảnh gốc
  }

  List<double> _preprocessImage(img.Image image) {
    // Tính toán padding để tạo hình vuông
    final maxDim = max(image.width, image.height);
    final paddingX = (maxDim - image.width) ~/ 2;
    final paddingY = (maxDim - image.height) ~/ 2;
    
    // Tạo ảnh vuông với padding đen
    final paddedImage = img.copyResize(
      image,
      width: maxDim,
      height: maxDim,
      backgroundColor: img.ColorUint8.rgb(0, 0, 0),
    );
    
    // Resize về 640x640
    final resized = img.copyResize(paddedImage, width: 640, height: 640);
    
    // Chuyển thành tensor format [1, 640, 640, 3]
    var tensor = List<double>.filled(1 * 640 * 640 * 3, 0);
    var index = 0;
    
    for (var y = 0; y < resized.height; y++) {
      for (var x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        tensor[index++] = (pixel.r / 255.0);
        tensor[index++] = (pixel.g / 255.0);
        tensor[index++] = (pixel.b / 255.0);
      }
    }
    
    return tensor;
  }

  List<ChessPosition> _postprocessYolov11(List<List<double>> output) {
    final List<ChessPosition> positions = [];
    final confidenceThreshold = 0.25;
    
    for (var i = 0; i < 8400; i++) {
      final confidence = output[4][i];
      if (confidence < confidenceThreshold) continue;
      
      var maxClass = 0;
      var maxScore = output[4][i];
      for (var c = 5; c < 19; c++) {
        if (output[c][i] > maxScore) {
          maxScore = output[c][i];
          maxClass = c - 5;
        }
      }
      
      final x = output[0][i];
      final y = output[1][i];
      
      final pieceNames = [
        'b_bing', 'b_che', 'b_jiang', 'b_ma',
        'b_pao', 'b_shi', 'b_xiang', 'board',
        'r_bing', 'r_che', 'r_jiang', 'r_ma',
        'r_pao', 'r_shi', 'r_xiang'
      ];
      
      if (maxClass < pieceNames.length) {
        positions.add(ChessPosition(
          pieceNames[maxClass],
          x,
          y
        ));
      }
    }
    
    return positions;
  }

  List<ChessPosition> _transformPositions(
    List<ChessPosition> positions,
    List<Point<int>> boardCorners
  ) {
    // Transform vị trí từ ảnh đã xử lý về vị trí thực tế trên bàn cờ
    return positions.map((pos) {
      // Tính toán tọa độ thực từ tọa độ chuẩn hóa và góc bàn cờ
      final realX = _interpolatePosition(pos.x, boardCorners, true);
      final realY = _interpolatePosition(pos.y, boardCorners, false);
      
      return ChessPosition(pos.piece, realX, realY);
    }).toList();
  }

  double _interpolatePosition(
    double normalizedPos,
    List<Point<int>> corners,
    bool isX
  ) {
    // Tính toán vị trí thực dựa trên perspective transform
    if (isX) {
      final topDist = corners[1].x - corners[0].x;
      final bottomDist = corners[2].x - corners[3].x;
      final t = normalizedPos;
      return corners[0].x + (t * topDist + (1 - t) * bottomDist) * normalizedPos;
    } else {
      final leftDist = corners[3].y - corners[0].y;
      final rightDist = corners[2].y - corners[1].y;
      final t = normalizedPos;
      return corners[0].y + (t * leftDist + (1 - t) * rightDist) * normalizedPos;
    }
  }

  String generateFEN(List<ChessPosition> positions) {
    // Tạo bàn cờ trống
    List<List<String>> board = List.generate(
      10, (_) => List.filled(9, ''));
    
    // Map vị trí thực về vị trí bàn cờ
    for (var pos in positions) {
      final boardX = (pos.x * 8).round();
      final boardY = (pos.y * 9).round();
      
      if (boardX >= 0 && boardX < 9 && boardY >= 0 && boardY < 10) {
        board[boardY][boardX] = _pieceToFen(pos.piece);
      }
    }
    
    // Chuyển thành FEN string
    final StringBuffer fen = StringBuffer();
    
    for (var row in board) {
      var emptyCount = 0;
      
      for (var piece in row) {
        if (piece.isEmpty) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            fen.write(emptyCount);
            emptyCount = 0;
          }
          fen.write(piece);
        }
      }
      
      if (emptyCount > 0) {
        fen.write(emptyCount);
      }
      
      fen.write('/');
    }
    
    String fenStr = fen.toString().substring(0, fen.length - 1);
    fenStr += ' w - - 0 1';
    
    return fenStr;
  }

  void dispose() {
    _interpreter.close();
  }
}