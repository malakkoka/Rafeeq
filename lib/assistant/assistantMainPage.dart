// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:front/assistant/assistanceRequestPage.dart';
import 'package:front/assistant/assistantpage.dart';
import 'package:front/color.dart';
import 'package:front/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Assistantmainpage extends StatefulWidget {
  const Assistantmainpage({super.key});

  @override
  State<Assistantmainpage> createState() => _AssistantmainpageState();
}

class _AssistantmainpageState extends State<Assistantmainpage> {
  int _currentIndex = 2;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      SettingsPage(), // 0
      AssistanceRequestPage(), // 1
      AssistantPage(), // 2
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 48,
        backgroundColor: AppColors.background,
        color: AppColors.n1,
        // animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.linearToEaseOut,
        items: const <Widget>[
          Icon(Icons.settings, size: 25, color: Colors.white),
          Icon(Icons.add, size: 28, color: Colors.white),
          Icon(Icons.accessibility_new, size: 25, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
