// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:rtp_silver/screens/home_page.dart';
import 'package:rtp_silver/screens/employee_management.dart';
void main() async {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
