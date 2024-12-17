import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rose_flutter/engine/rose.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<Rose> _roseFuture;
  StreamSubscription<String>? _stdoutSubscription;
  Rose? _roseInstance;

  @override
  void initState() {
    super.initState();
    _roseFuture = roseAsync().then((rose) {
      _roseInstance = rose;
      // Lắng nghe sự kiện từ engine trong initState
      rose.state.addListener(_onRoseStateChanged);
      _stdoutSubscription = rose.stdout.listen(_onRoseStdoutReceived);
       _roseInstance!.stdin ='uci\n';
      return rose;
    });

   
  }

  void _onRoseStateChanged() {
    print('Engine state: ${_roseInstance?.state.value}');
  }

  void _onRoseStdoutReceived(String line) {
    print('Engine output: $line');
  }

  @override
  void dispose() {
    _stdoutSubscription?.cancel();
    _roseInstance?.state.removeListener(_onRoseStateChanged);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<Rose>(
        future: _roseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Không cần kiểm tra hasListeners ở đây nữa
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}