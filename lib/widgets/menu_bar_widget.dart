import 'package:flutter/material.dart';

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