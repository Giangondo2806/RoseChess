import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../providers/book_state.dart';
import '../providers/user_settings_provider.dart';
import 'book_item_widget.dart';

class BookContent extends StatelessWidget {
  const BookContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookState = Provider.of<BookState>(context);
    final theme = Provider.of<UserSettingsProvider>(context).currentTheme;
    final lang = AppLocalizations.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            child: Container(
              height: 40,
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(lang.move,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(lang.score,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(lang.winrate,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            theme: theme,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final move = bookState.moves[index];
              return Column(
                children: [
                  BookItem(move: move),
                  Divider(
                    thickness: 0.5,
                  ),
                ],
              );
            },
            childCount: bookState.moves.length,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child, required this.theme});

  final Widget child;
  final ThemeData theme;

  @override
  double get minExtent => 40; // Chiều cao tối thiểu của header

  @override
  double get maxExtent => 40; // Chiều cao tối đa của header

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
