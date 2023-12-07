import 'package:bpm_app/pages/analyzer.dart';
import 'package:bpm_app/pages/history.dart';
import 'package:bpm_app/pages/tapper.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Tapper(),
    const Analyzer(),
    const History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.itunesNote,
                  text: 'Tapper',
                ),
                GButton(
                  icon: LineIcons.microphone,
                  text: 'Analyzer',
                ),
                GButton(
                  icon: LineIcons.history,
                  text: 'History',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) async {
                setState(() {
                  selectedIndex = index;
                });

                if (selectedIndex == 1 &&
                    await Permission.microphone.status.isDenied) {
                  await Permission.microphone.request();
                } else {
                  print(await Permission.microphone.status);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
