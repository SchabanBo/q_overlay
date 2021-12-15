import 'package:example/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:q_overlay/q_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<NavigatorState>();
    QOverlay.navigationKey = key;
    return MaterialApp(
      navigatorKey: key,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QOverlay'),
        ),
        body: const MainScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: QOverlay.dismissAll,
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
