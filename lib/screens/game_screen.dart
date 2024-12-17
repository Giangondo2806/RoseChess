import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/engine_utils.dart';

class GameScreen extends StatelessWidget {
  final String engineFileName;

  const GameScreen({Key? key, required this.engineFileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<File>(
          future: EngineUtils.getEngineFile(engineFileName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Text(
                  'Engine file path: ${snapshot.data!.path}',
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}