import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings_provider.dart';

class GraphContent extends StatelessWidget {
  const GraphContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Nội dung Graph ở đây.",
                style: userSettingsProvider.currentTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}