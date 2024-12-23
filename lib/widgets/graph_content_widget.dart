import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class GraphContent extends StatelessWidget {
  const GraphContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Nội dung Graph ở đây.",
                style: themeProvider.currentTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}