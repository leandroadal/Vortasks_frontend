import 'package:flutter/material.dart';
import 'package:flutter_test_application/pages/home/home_page.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vortasks',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Vortasks'),
    );
  }
}

String generateUUID() {
  var uuid = Uuid();
  return uuid.v4();
}
