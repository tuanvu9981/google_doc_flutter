import 'package:flutter/material.dart';

void main() {
  runApp(const GgDocsApp());
}

class GgDocsApp extends StatelessWidget {
  const GgDocsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
