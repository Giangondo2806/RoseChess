import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/engine_utils.dart';
import '../widgets/ches_board.dart';

class SoftwareScreen extends StatefulWidget {
  final String engineFileName;

  const SoftwareScreen({Key? key, required this.engineFileName})
      : super(key: key);

  @override
  State<SoftwareScreen> createState() => _SoftwareScreenState();
}

class _SoftwareScreenState extends State<SoftwareScreen> {
  // Hàm xử lý sự kiện từ MenuBarWidget
  void _handleMenuAction(String action) {
    print('Menu action received: $action');
    // Xử lý các sự kiện tương ứng
    switch (action) {
      case 'new_game':
        // Xử lý New Game
        break;
      case 'detect_image':
        // Xử lý Detect Image
        break;
      case 'flip_board':
        // Xử lý Flip Board
        break;
      case 'settings':
        // Xử lý Settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Truyền callback function _handleMenuAction vào MenuBarWidget
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: MenuBarWidget(onMenuAction: _handleMenuAction),
          ),
          Expanded(
            child: ChessBoardWidget(),
          ),
          AnalysisWidget(),
        ],
      ),
    );
  }
}

// Widget cho thanh công cụ MenuBar
class MenuBarWidget extends StatelessWidget {
  // Thêm callback function onMenuAction
  final Function(String) onMenuAction;

  const MenuBarWidget({Key? key, required this.onMenuAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          tooltip: 'New Game',
          onPressed: () {
            // Gọi callback function để emit event 'new_game'
            onMenuAction('new_game');
          },
        ),
        IconButton(
          icon: const Icon(Icons.image_search),
          tooltip: 'Detect Image',
          onPressed: () {
            // Gọi callback function để emit event 'detect_image'
            onMenuAction('detect_image');
          },
        ),
        IconButton(
          icon: const Icon(Icons.flip),
          tooltip: 'Flip Board',
          onPressed: () {
            // Gọi callback function để emit event 'flip_board'
            onMenuAction('flip_board');
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            // Gọi callback function để emit event 'settings'
            onMenuAction('settings');
          },
        ),
        // Thêm các icon khác nếu cần
      ],
    );
  }
}



// Widget cho phần phân tích và hướng dẫn
class AnalysisWidget extends StatefulWidget {
  const AnalysisWidget({Key? key}) : super(key: key);

  @override
  State<AnalysisWidget> createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phân tích ván cờ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Thêm nội dung phân tích và hướng dẫn ở đây
          Text("Hướng dẫn nước đi..."),
        ],
      ),
    );
  }
}
