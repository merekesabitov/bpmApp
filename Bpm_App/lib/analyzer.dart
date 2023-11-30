import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class Analyzer extends StatefulWidget {
  const Analyzer({Key? key}) : super(key: key);

  @override
  State<Analyzer> createState() => _AnalyzerState();
}

class _AnalyzerState extends State<Analyzer> {
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  NoiseMeter? noiseMeter;
  List<double> beatTimes = [];
  double dynamicThreshold = 0;
  NoiseReading? noiseReading;
  double bpmResult = 0;
  int beatsCount = 0;

  @override
  void dispose() {
    noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading data) {
    setState(() {
      noiseReading = data;
    });

    double currentTime = DateTime.now().microsecondsSinceEpoch / 1000000.0;

    if (beatTimes.isNotEmpty) {
      double timeSinceLastBeat = currentTime - beatTimes.last;

      // Добавлен порог входа децибела
      if (data.maxDecibel > DBC_THRESHOLD &&
          data.maxDecibel > dynamicThreshold &&
          timeSinceLastBeat > MIN_TIME_BETWEEN_BEATS &&
          timeSinceLastBeat < MAX_TIME_BETWEEN_BEATS) {
        beatTimes.add(currentTime);
        beatsCount++;

        // Update dynamic threshold with a weak filter
        dynamicThreshold = 0.8 * dynamicThreshold + 0.2 * data.maxDecibel;

        print('Beat detected. Total Beats: ${beatTimes.length}');

        if (beatsCount % 3 == 0) {
          calculateAndDisplayBPM();
        }
      }
    } else {
      // Добавляем первый удар в случае отсутствия предыдущих ударов
      beatTimes.add(currentTime);
    }
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future<void> start() async {
    noiseMeter ??= NoiseMeter();

    if (!(await checkPermission())) await requestPermission();

    await analyzeForBPM();
  }

  Future<void> analyzeForBPM() async {
    beatTimes.clear();
    noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => isRecording = true);

    await Future.delayed(Duration(seconds: ANALYSIS_INTERVAL));
    stop();
    calculateAndDisplayBPM();
  }

  void stop() {
    noiseSubscription?.cancel();
    setState(() {
      isRecording = false;
      beatsCount = 0; // Сбросить счетчик ударов при остановке
    });
  }

  void calculateAndDisplayBPM() {
    if (beatTimes.length >= MIN_BEATS_FOR_BPM_CALCULATION) {
      double totalTime = beatTimes.last - beatTimes.first;
      double averageTimeBetweenBeats = totalTime / (beatTimes.length - 1);
      double bpm = 60 / averageTimeBetweenBeats;

      print('BPM: ${bpm.toStringAsFixed(2)}');

      setState(() {
        bpmResult = bpm;
      });
    } else {
      print('Недостаточно ударов для расчета BPM. Всего ударов: ${beatTimes.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      isRecording ? "Mic: ON" : "Mic: OFF",
                      style: const TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Noise: ${noiseReading?.meanDecibel.toStringAsFixed(2) ?? 'N/A'} dB',
                    ),
                  ),
                  Container(
                    child: Text(
                      'Max: ${noiseReading?.maxDecibel.toStringAsFixed(2) ?? 'N/A'} dB',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'BPM Result: ${bpmResult.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isRecording ? Colors.red : Colors.green,
        onPressed: isRecording ? stop : start,
        child: isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
      ),
    );
  }
}

const double MIN_TIME_BETWEEN_BEATS = 0.2;
const double MAX_TIME_BETWEEN_BEATS = 1.5;
const int ANALYSIS_INTERVAL = 20;
const int MIN_BEATS_FOR_BPM_CALCULATION = 4;
const double DBC_THRESHOLD = 60.0; // Добавлен порог входа децибела
