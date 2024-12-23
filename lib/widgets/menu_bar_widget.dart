import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class MenuBarWidget extends StatelessWidget {
  final Function(String) onMenuAction;
  final double iconPadding = 2.0; // Điều chỉnh padding
  final double iconSize = 24.0; // Điều chỉnh kích thước icon

  const MenuBarWidget({Key? key, required this.onMenuAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy các icon ra xa nhau tối đa
      children: [
        InkWell(
          onTap: () {
            onMenuAction('new_game');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.note_add_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('auto_red');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.computer_outlined, size: iconSize, color: Colors.red),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('auto_black');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.computer_outlined, size: iconSize, color: Colors.black),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('enable_engine');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.search_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('quick_move');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.bolt_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('flip_board');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.flip_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('edit');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.edit_document, size: iconSize),
          ),
        ),
           InkWell(
          onTap: () {
            onMenuAction('copy');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.content_copy_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
            onMenuAction('detect_image');
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.image_search_outlined, size: iconSize),
          ),
        ),
        InkWell(
          onTap: () {
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
          },
          child: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: Icon(Icons.settings_outlined, size: iconSize),
          ),
        ),
      ],
    );
  }
}