import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final navigationWidth = screenWidth / 2;
    final contentWidth = screenWidth - navigationWidth;

    return Column(
      children: [
        Container(
          color: themeProvider.currentTheme.appBarTheme.backgroundColor,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Phân tích"),
              Tab(text: "Book"),
              Tab(text: "Graph"),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _showNavigation ? contentWidth : screenWidth,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          EngineAnalysisContent(),
                          const BookContent(),
                          const GraphContent(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: navigationWidth,
                child: _showNavigation
                    ? const NavigationContent()
                    : Container(), // Ẩn NavigationContent khi _showNavigation là false
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: 10,
                right: _showNavigation ? navigationWidth : 10,
                // left: _showNavigation ? 5 : null,
                // Đặt width cố định cho AnimatedPositioned
                width: 40,
                child: SizedBox(
                  height: 40,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        color: _showNavigation
                            ? Colors.red
                            : Colors.grey, // Màu đỏ khi mở, xám khi đóng
                        borderRadius: BorderRadius.circular(8)),
                    child: Material(
                      color: Colors.transparent,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
