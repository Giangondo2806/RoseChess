import 'package:flutter/material.dart';
import 'package:rose_chess/utils/toast.dart';
import 'package:toastification/toastification.dart';
import '../screens/settings_screen.dart';

class MenuBarWidget extends StatelessWidget {
  final Function(String) onMenuAction;
  final Function() onEditBoard;
  final double iconPadding = 2.0;
  final double iconSize = 24.0;
  final double enabledIconSize = 20.0; // Kích thước icon khi enable

  final bool automoveRed;
  final bool automoveBlack;
  final bool searchModeEnabled;

  const MenuBarWidget({
    Key? key,
    required this.onMenuAction,
    required this.onEditBoard,
    required this.automoveRed,
    required this.automoveBlack,
    required this.searchModeEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: automoveRed ? Colors.red.withAlpha(128) : null,
                  border: automoveRed
                      ? Border.all(color: Colors.red, width: 2.0)
                      : null,
                  borderRadius: BorderRadius.circular(4.0),
                ), // Padding không đổi
                child: Icon(Icons.computer_outlined,
                    size: automoveRed
                        ? enabledIconSize
                        : iconSize, // Thay đổi size
                    color: Colors.red),
              ),
            ),
            InkWell(
              onTap: () {
                onMenuAction('auto_black');
              },
              child: Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: automoveBlack ? Colors.black.withAlpha(128) : null,
                  border: automoveBlack
                      ? Border.all(color: Colors.black, width: 2.0)
                      : null,
                  borderRadius: BorderRadius.circular(4.0),
                ), // Padding không đổi
                child: Icon(Icons.computer_outlined,
                    size: automoveBlack
                        ? enabledIconSize
                        : iconSize, // Thay đổi size
                    color: Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                onMenuAction('enable_engine');
              },
              child: Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: searchModeEnabled
                      ? Color.fromARGB(255, 157, 72, 112).withAlpha(128)
                      : null,
                  border: searchModeEnabled
                      ? Border.all(
                          color: Color.fromARGB(255, 157, 72, 112), width: 2.0)
                      : null,
                  borderRadius: BorderRadius.circular(4.0),
                ), // Padding không đổi
                child: Icon(
                  Icons.search_outlined,
                  size: searchModeEnabled ? enabledIconSize : iconSize,
                ),
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
              onTap: onEditBoard,
              child: Padding(
                padding: EdgeInsets.all(iconPadding),
                child: Icon(Icons.edit_document, size: iconSize),
              ),
            ),
            InkWell(
              onTap: () {
                toast(
                  context: context,
                  title: 'Sao chép bàn cờ thành công!',
                  description: 'Nội dung FEN đã được sao chép',
                  type: ToastificationType.success,
                );
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
        ));
  }
}
