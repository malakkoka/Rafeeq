import 'package:front/component/customlisttile.dart';
import '../theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool notificationOn = false;
  bool darkModeOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("images/OIP.webp"),
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 5, right: 10),
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.asset(
                              "images/OIP.webp",
                              fit: BoxFit.cover,
                            ))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Walaa",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "walaamhmd@gmail.com",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Align(
                              child: SizedBox(
                                width: 110,
                                height: 40,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "editprofile");
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: const Color.fromARGB(255, 28, 79, 127),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                      Icons.dark_mode,
                      color: Colors.grey.shade700,
                    ),
                    title: Text("Theme",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: Transform.scale(
                      alignment: Alignment.centerRight,
                      scale: 0.7,
                      child: Switch(
                        activeTrackColor:
                            const Color.fromARGB(255, 28, 79, 127),
                        value: darkModeOn,
                        onChanged: (value) {
                          setState(() {
                            darkModeOn = value;
                            Provider.of<Themeprovider>(context, listen: false)
                                .toggleTheme();
                          });
                        },
                      ),
                    )),
                ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.grey.shade700,
                    ),
                    title: Text("Notifications",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: Transform.scale(
                      alignment: Alignment.centerRight,
                      scale: 0.7,
                      child: Switch(
                        activeTrackColor:
                            const Color.fromARGB(255, 28, 79, 127),
                        value: notificationOn,
                        onChanged: (value) {
                          setState(() {
                            notificationOn = value;
                          });
                        },
                      ),
                    )),
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
                    child: Icon(
                      Icons.logout,
                      color: const Color.fromARGB(255, 28, 79, 127),
                    ),
                  ),
                  title: Text("Logout",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 28, 79, 127),
                      )),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
