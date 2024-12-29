import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_state.dart';
import '../providers/user_settings_provider.dart';

class NavigationContent extends StatelessWidget {
  const NavigationContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);

    return Material(
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
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: navigationState.moves.length,
              itemBuilder: (context, index) {
                final move = navigationState.moves[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text((index + 1).toString(),
                            style: userSettingsProvider
                                .currentTheme.textTheme.bodyMedium),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 1,
                        child: move['move1'] != null
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 4.0),
                                ),
                                onPressed: () {
                                  navigationState.gotoMove(move['move1']!);
                                },
                                child: Text(move['move1']!.san!),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        flex: 1,
                        child: move['move2'] != null
                            ? ElevatedButton(                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 4.0),
                                ),
                                onPressed: () {
                                  navigationState.gotoMove(move['move2']!);
                                },
                                child: Text(move['move2']!.san!),
                              )
                            : const SizedBox.shrink(),
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
}