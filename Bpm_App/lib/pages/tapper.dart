import 'package:flutter/material.dart';

class Tapper extends StatefulWidget {
  const Tapper({super.key});

  @override
  TapperState createState() => TapperState();
}

class TapperState extends State<Tapper> {
  
  int tapCount = 0;
  double bpm = 0;
  DateTime? lastTapTime;

  void _onTap() {
    DateTime now = DateTime.now();

    if (lastTapTime != null) {
      double timeElapsed = now.difference(lastTapTime ?? now).inMilliseconds / 1000;
      double newBPM = 60 / timeElapsed;

      // Weighted average to smooth out BPM changes
      bpm = (bpm * tapCount + newBPM) / (tapCount + 1);
    }

    setState(() {
      tapCount++;
    });

    lastTapTime = now;
  }

  void _reset() {
    setState(() {
      tapCount = 0;
      bpm = 0;
      lastTapTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Tap the button to measure BPM',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                '${bpm.round()} BPM',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => _onTap(),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(6, 6),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
              
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-6, -6),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'TAP',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => _reset(),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(6, 6),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
              
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-6, -6),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'RESET',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

