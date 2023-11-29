import 'package:bpm_app/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[800],
      ),
      home: const InitialPage(),
    ));
