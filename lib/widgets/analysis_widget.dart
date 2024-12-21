import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_flutter/providers/book_state.dart';

import '../providers/engine_analysis_state.dart';
import '../providers/theme_provider.dart';
import 'book_item_widget.dart';

class AnalysisWidget extends StatefulWidget {
  const AnalysisWidget({Key? key}) : super(key: key);

  @override
  State<AnalysisWidget> createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget>
    with SingleTickerProviderStateMixin {
  bool _showNavigation = false;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<String> mockMoves = [
    "1: a1b2 c6d7",
    "2: b2c2 g3g5",
    "3: e2e4 d7d5",
    "4: g1f3 b8c6",
    "5: f1b5 c8g4",
    "6: e1g1 g8f6",
    "7: h2h3 h7h6",
    "8: d2d3 f8e7"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final engineAnalysisState =
        Provider.of<EngineAnalysisState>(context, listen: false);
    engineAnalysisState.addListener(() {
      if (engineAnalysisState.engineAnalysis.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engineAnalysisState = Provider.of<EngineAnalysisState>(context);
    final bookState = Provider.of<BookState>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final navigationWidth = screenWidth / 2;
    final contentWidth = screenWidth - navigationWidth;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentTheme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          // TabBar
          color: themeProvider.currentTheme.appBarTheme.backgroundColor,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
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
                          // Phân tích
                          CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        ...engineAnalysisState.engineAnalysis
                                            .map((engineInfo) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Text(
                                                  engineInfo.title,
                                                  style: themeProvider
                                                      .currentTheme
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(
                                                  engineInfo.moves,
                                                  style: themeProvider
                                                      .currentTheme
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Book
                          CustomScrollView(
                            slivers: <Widget>[
                              // Tiêu đề cố định
                              SliverPersistentHeader(
                                pinned: true, // Để tiêu đề cố định
                                delegate: _SliverAppBarDelegate(
                                  child: Container(
                                    height:
                                        40, // Thêm chiều cao xác định cho Container
                                    color: themeProvider.currentTheme
                                        .appBarTheme.backgroundColor,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text('Move',
                                              style: themeProvider.currentTheme
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          child: Text('Score',
                                              style: themeProvider.currentTheme
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          child: Text('Winrate',
                                              style: themeProvider.currentTheme
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Danh sách BookItem
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final move = bookState.moves[index];
                                    return Column(
                                      children: [
                                        BookItem(move: move),
                                        Divider(
                                          thickness: 0.5,
                                          color: isDarkMode
                                              ? const Color(0xFF404040)
                                              : const Color(0xFFE0E0E0),
                                        ),
                                      ],
                                    );
                                  },
                                  childCount: bookState.moves.length,
                                ),
                              ),
                            ],
                          ),

                          // Graph
                          CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Nội dung Graph ở đây.",
                                      style: themeProvider
                                          .currentTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(
                      _showNavigation ? 0 : navigationWidth, 0, 0),
                  child: Material(
                    color: themeProvider.currentTheme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        // Bốn nút điều hướng
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      // Xử lý sự kiện <<
                                    },
                                    icon: Icon(Icons.fast_rewind,
                                        color: themeProvider.currentTheme
                                            .textTheme.bodyLarge!.color),
                                    tooltip: 'Về đầu',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      // Xử lý sự kiện <
                                    },
                                    icon: Icon(Icons.arrow_back,
                                        color: themeProvider.currentTheme
                                            .textTheme.bodyLarge!.color),
                                    tooltip: 'Lùi lại',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      // Xử lý sự kiện >
                                    },
                                    icon: Icon(Icons.arrow_forward,
                                        color: themeProvider.currentTheme
                                            .textTheme.bodyLarge!.color),
                                    tooltip: 'Tiến lên',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      // Xử lý sự kiện >>
                                    },
                                    icon: Icon(Icons.fast_forward,
                                        color: themeProvider.currentTheme
                                            .textTheme.bodyLarge!.color),
                                    tooltip: 'Đến cuối',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Thanh phân cách
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: isDarkMode
                                ? const Color(0xFF404040)
                                : const Color(0xFFE0E0E0)),

                        // Danh sách nước đi
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 8.0),
                            itemCount: mockMoves.length,
                            itemBuilder: (context, index) {
                              final parts = mockMoves[index].split(' ');
                              final moveNumber = parts[0];
                              final move1 = parts[1];
                              final move2 = parts.length > 2 ? parts[2] : '';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // Giới hạn kích thước Row
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(moveNumber,
                                          style: themeProvider.currentTheme
                                              .textTheme.bodyMedium),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkMode
                                                ? const Color(0xFF404040)
                                                : Colors.grey[300],
                                            foregroundColor: themeProvider
                                                .currentTheme
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                          onPressed: () {
                                            print(
                                                "Đã nhấn vào nước đi: $move1");
                                          },
                                          child: Text(move1),
                                        ),
                                      ),
                                    ),
                                    if (move2.isNotEmpty) ...[
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isDarkMode
                                                  ? const Color(0xFF404040)
                                                  : Colors.grey[300],
                                              foregroundColor: themeProvider
                                                  .currentTheme
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                            ),
                                            onPressed: () {
                                              print(
                                                  "Đã nhấn vào nước đi: $move2");
                                            },
                                            child: Text(move2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Nút toggle
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

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
    return false;
  }
}
