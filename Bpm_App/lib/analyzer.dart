import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

class Analyzer extends StatefulWidget {
  const Analyzer({super.key});

  @override
  State<Analyzer> createState() => _AnalyzerState();
}

class _AnalyzerState extends State<Analyzer> {
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;

  @override
  Widget build(BuildContext context) {
    return const Scaffold( 
      backgroundColor: Colors.green,
    );
  }
}