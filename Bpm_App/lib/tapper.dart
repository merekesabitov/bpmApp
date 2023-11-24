import 'package:flutter/material.dart';

class Tapper extends StatefulWidget {
  const Tapper({super.key});

  @override
  State<Tapper> createState() => _TapperState();
}

class _TapperState extends State<Tapper> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold( 
      backgroundColor: Colors.blue,
    );
  }
}