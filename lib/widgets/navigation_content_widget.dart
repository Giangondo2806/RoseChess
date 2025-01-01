import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_state.dart';
import '../providers/user_settings_provider.dart';

class NavigationContent extends StatefulWidget {
  const NavigationContent({Key? key}) : super(key: key);

  @override
  State<NavigationContent> createState() => NavigationContentState();
}

class NavigationContentState extends State<NavigationContent> {
  final ScrollController _scrollController = ScrollController();

  // Map để lưu trữ các GlobalKey cho mỗi item
  final Map<int, GlobalKey> itemKeys = {};

  @override
  void initState() {
    super.initState();
    // Truyền tham chiếu của NavigationContentState vào NavigationState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationState>(context, listen: false)
          .setNavigationContentState(this);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);
    navigationState.scrollController = _scrollController;

    return Material(
      borderOnForeground: true,
      color: userSettingsProvider.currentTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () {
                        navigationState.gotoFistMove();
                      },
                      icon: const Icon(Icons.fast_rewind),
                      tooltip: 'Về đầu',
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () {
                        navigationState.previousMove();
                      },
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Lùi lại',
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () {
                        navigationState.nextMove();
                      },
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Tiến lên',
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () {
                        navigationState.gotoLastMove();
                      },
                      icon: const Icon(Icons.fast_forward),
                      tooltip: 'Đến cuối',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              itemCount: (navigationState.moves.length + 1) ~/ 2,
              itemBuilder: (context, index) {
                final moveIndex1 = index * 2;
                final moveIndex2 = moveIndex1 + 1;
                final move1 = moveIndex1 < navigationState.moves.length
                    ? navigationState.moves[moveIndex1]
                    : null;
                final move2 = moveIndex2 < navigationState.moves.length
                    ? navigationState.moves[moveIndex2]
                    : null;
                final hightLightMove = navigationState.hightLightMove;

                // Tạo GlobalKey cho item này nếu chưa tồn tại
                itemKeys[index] ??= GlobalKey();

                return Padding(
                  key: itemKeys[index], // Gán GlobalKey vào Row widget
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text(
                          (index + 1).toString(),
                          style: userSettingsProvider
                              .currentTheme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: _buildMoveButton(
                          move1,
                          hightLightMove,
                          navigationState,
                          userSettingsProvider,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: _buildMoveButton(
                          move2,
                          hightLightMove,
                          navigationState,
                          userSettingsProvider,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveButton(
    dynamic move,
    dynamic hightLightMove,
    NavigationState navigationState,
    UserSettingsProvider userSettingsProvider,
  ) {
    if (move == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        navigationState.gotoMove(move);
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: move == hightLightMove
                ? const Color.fromARGB(255, 157, 72, 112)
                : Colors.grey,
          ),
        ),
        child: Text(
          move.san,
          style: TextStyle(
            color: move == hightLightMove
                ? const Color.fromARGB(255, 157, 72, 112)
                : userSettingsProvider.currentTheme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}