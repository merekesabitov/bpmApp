import 'package:flutter/material.dart';

class Tapper extends StatefulWidget {
  const Tapper({super.key});

  @override
  TapperState createState() => TapperState();
}

class TapperState extends State<Tapper> {
  int tapCount = 0;
  double _bpm = 0;
  DateTime? lastTapTime;

  void _onTap() {
    DateTime now = DateTime.now();

    if (lastTapTime != null) {
      double timeElapsed = now.difference(lastTapTime!).inMilliseconds / 1000;
      double newBPM = 60 / timeElapsed;
      setState(() {
        _bpm = newBPM;
      });
    }

    setState(() {
      tapCount++;
      lastTapTime = now;
    });
  }

  void _reset() {
    setState(() {
      tapCount = 0;
      _bpm = 0;
      lastTapTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempo Measurement'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tap the button to measure BPM',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${_bpm.round()} BPM',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onTap,
              child: const Text('Tap'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
