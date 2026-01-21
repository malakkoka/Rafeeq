import 'package:front/color.dart';
import 'package:front/component/customlisttile.dart';
import 'package:front/component/viewinfo.dart';
import 'package:flutter/material.dart';
import 'package:front/emergencymode/fall_detector.dart';
import 'package:front/provider/user_provider.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Drawer(
      backgroundColor: AppColors.background,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 10),
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset(
                      "images/OIP.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 110,
                          height: 40,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewInfo(),
                                ),
                              );
                            },
                            color: const Color.fromARGB(255, 28, 79, 127),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //Emergency Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                activeColor: Colors.red,
                title: const Text(
                  "Emergency Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                /*subtitle: Text(
                  user.emergencyEnabled
                      ? "Emergency mode is ON"
                      : "Emergency mode is OFF",
                ),*/
                value: user.emergencyEnabled,
                onChanged: (value) {
                  user.toggleEmergency(value);

                  if (value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FallDetector(),
        ),
      );
    }
                },
              ),
            ),

            const SizedBox(height: 15),

            CustomListTile(
              icon: Icons.home,
              color: Colors.grey.shade700,
              textTitle: 'Home',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.grey.shade700,
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              
            ),
            CustomListTile(
              icon: Icons.location_on_rounded,
              color: Colors.grey.shade700,
              textTitle: "Location",
              onTap: () {},
            ),
            CustomListTile(
              icon: Icons.language,
              color: Colors.grey.shade700,
              textTitle: "Language",
              onTap: () {},
            ),
            CustomListTile(
              icon: Icons.accessibility,
              color: Colors.grey.shade700,
              textTitle: "Accessibility Tools",
              onTap: () {},
            ),
            CustomListTile(
              icon: Icons.feedback,
              color: Colors.grey.shade700,
              textTitle: "Feedback",
              onTap: () {},
            ),
            CustomListTile(
              icon: Icons.phone,
              color: Colors.grey.shade700,
              textTitle: "Contact Us",
              onTap: () {},
            ),

            ListTile(
              leading: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 28, 79, 127),
                ),
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 28, 79, 127),
                ),
              ),
              onTap: () {
                user.clearUser();
                Navigator.of(context).pushReplacementNamed("login");
              },
            ),
          ],
        ),
      ),
    );
  }
}