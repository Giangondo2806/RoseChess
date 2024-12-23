import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/engine_analysis_state.dart';
import '../providers/theme_provider.dart';

class EngineAnalysisContent extends StatefulWidget {
  const EngineAnalysisContent({Key? key}) : super(key: key);

  @override
  State<EngineAnalysisContent> createState() => _EngineAnalysisContentState();
}

class _EngineAnalysisContentState extends State<EngineAnalysisContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engineAnalysisState = Provider.of<EngineAnalysisState>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ...engineAnalysisState.engineAnalysis.map((engineInfo) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            engineInfo.title,
                            style: themeProvider
                                .currentTheme.textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            engineInfo.moves,
                            style:
                                themeProvider.currentTheme.textTheme.bodyMedium,
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
    );
  }
}
