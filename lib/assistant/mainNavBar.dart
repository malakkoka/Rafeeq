import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:front/auth/call/vediocall.dart';
import 'package:front/auth/volunteer/activityscreen.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/volunteerpage.dart';
import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:front/homepage.dart';
import 'package:front/settings.dart';

// assistant pages
import 'package:front/assistant/assistantpage.dart';
import 'package:front/assistant/assistanceRequestPage.dart';

// volunteer pages
class MainNavigationPage extends StatefulWidget {
  final UserRole role; 

  const MainNavigationPage({
    super.key,
    required this.role, 
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late List<Widget> pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // تحديد الصفحات بناءً على الدور (Assistant أو Volunteer)
    if (widget.role == UserRole.assistant) {
<<<<<<< HEAD
      pages = [
        const SettingsPage(), // 0
        const AssistanceRequestPage(), // 1
        const Homepage(), // 2
=======
      pages = const [
        SettingsPage(), // 0
        AssistanceRequestPage(), // 1
        Vediocall(), // 2ب
>>>>>>> 68eb14e82717cccb5e9009926e5af18faa281504
        AssistantPage(), // 3
      ];
      _currentIndex = 3;
    } else {
      pages = [
        const SettingsPage(), // 0
        VolunteerHome(), // تمرير post هنا
        VolunteerActivityScreen(), // تمرير post هنا
      ];
      _currentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: pages[_currentIndex], // عرض الصفحة بناءً على الفهرس الحالي
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 48,
        backgroundColor: AppColors.background,
        color: AppColors.n1,
        animationCurve: Curves.linearToEaseOut,
        items: _buildNavItems(),  // قائمة الأيقونات
        onTap: (index) {
          setState(() {
            _currentIndex = index; // تحديث الفهرس عند النقر
          });
        },
      ),
    );
  }

  // تحديد الأيقونات بناءً على الدور
  List<Widget> _buildNavItems() {
    if (widget.role == UserRole.assistant) {
      return const [
        Icon(Icons.settings, size: 25, color: Colors.white),
        Icon(Icons.add, size: 28, color: Colors.white),
        Icon(Icons.video_call, size: 25, color: Colors.white),
        Icon(Icons.accessibility_new, size: 25, color: Colors.white),
      ];
    } else {
      return const [
        Icon(Icons.settings, size: 25, color: Colors.white),
        Icon(Icons.volunteer_activism, size: 28, color: Colors.white),
        Icon(Icons.list_alt, size: 25, color: Colors.white),
      ];
    }
  }
}