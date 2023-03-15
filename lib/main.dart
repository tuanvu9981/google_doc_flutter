import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/screens/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: GgDocsApp()),
  );
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
      home: const LoginScreen(),
    );
  }
}
