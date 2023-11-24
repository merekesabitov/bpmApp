import 'package:flutter/material.dart';

class Analyzer extends StatefulWidget {
  const Analyzer({super.key});

  @override
  State<Analyzer> createState() => _AnalyzerState();
}

class _AnalyzerState extends State<Analyzer> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold( 
      backgroundColor: Colors.green,
    );
  }
}