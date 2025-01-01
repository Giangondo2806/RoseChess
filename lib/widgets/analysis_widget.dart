import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/themes/dark_theme.dart';
import '../generated/l10n.dart';
import '../providers/user_settings_provider.dart';
import 'book_content_widget.dart';
import 'engine_alalyis_content_widget.dart';
import 'graph_content_widget.dart';
import 'navigation_content_widget.dart';

class AnalysisWidget extends StatefulWidget {
  const AnalysisWidget({Key? key}) : super(key: key);

  @override
  State<AnalysisWidget> createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget>
    with SingleTickerProviderStateMixin {
  bool _showNavigation = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  hiddenNavigation() {
    if (_showNavigation) {
      setState(() {
        _showNavigation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<UserSettingsProvider>(context).currentTheme;
    final lang = AppLocalizations.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final navigationWidth = screenWidth / 2;

    return Column(
      children: [
        Container(
          color: theme == darkTheme
              ? theme.appBarTheme.backgroundColor
              : Color.fromARGB(255, 239, 232, 223),
          child: TabBar(
            controller: _tabController,
            // labelColor: userSettingsProvider.currentTheme.appBarTheme.titleTextStyle!.color,
            tabs: [
              Tab(text: lang.evaluation),
              Tab(text: lang.book),
              Tab(text: "Graph"),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Row chứa TabBarView
              Row(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: hiddenNavigation,
                          child: const EngineAnalysisContent(),
                        ),
                        GestureDetector(
                          onTap: hiddenNavigation,
                          child: const BookContent(),
                        ),
                        GestureDetector(
                          onTap: hiddenNavigation,
                          child: const GraphContent(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // NavigationContent
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: _showNavigation ? 0 : -navigationWidth,
                top: 0,
                bottom: 0,
                width: navigationWidth,
                curve: Curves.easeInOut,
                child: Container(
                  decoration: _showNavigation
                      ? BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha(128), // Màu của shadow
                              spreadRadius:
                                  -5, // Độ lan rộng của shadow (âm để lan về bên trái)
                              blurRadius: 7, // Độ mờ của shadow
                              offset: Offset(-5,
                                  0), // Vị trí của shadow (âm theo trục x để dịch sang trái)
                            ),
                          ],
                        )
                      : null,
                  child: const NavigationContent(),
                ),
              ),
              // Nút toggle
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: 10,
                right: _showNavigation ? navigationWidth : 10,
                width: 40,
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: 40,
                  child: Material(
                    color: _showNavigation ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _showNavigation = !_showNavigation;
                        });
                      },
                      child: Icon(
                        _showNavigation
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
