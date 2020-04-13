import 'package:flutter/material.dart';
import './widgets/collection.dart';

void main() => runApp(LeaferApp());

class LeaferApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.green[400]), home: Collection());
  }
}
