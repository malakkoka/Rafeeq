import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/viewinfo.dart';
import 'package:front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    const divider = Color(0xFFEFE7DA);
    const textPrimary = Color(0xFF1E1E1E);
    const textSecondary = Color(0xFF6B7280);
    const Color n1 = Color(0xFF23AAC3);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),

      /// ================= BODY =================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ===== Profile Card =====
              Material(
                color: AppColors.dialogcolor,
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: divider),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: n1.withOpacity(0.12),
                        backgroundImage:
                            const AssetImage("images/profilepatient.jpg"),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.name ?? '',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: n1,
                            side: BorderSide(color: n1.withOpacity(0.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ViewInfo()),
                            );
                          },
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// ===== Settings =====
              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.notifications,
                iconColor: n1,
                title: "Notifications",
                titleColor: textPrimary,
                subtitleColor: textSecondary,
                trailing: Switch(
                  value: true,
                  activeColor: n1,
                  onChanged: (v) {},
                ),
              ),
              SizedBox(height: 2),
              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.language,
                iconColor: n1,
                title: "Language",
                titleColor: textPrimary,
                subtitleColor: textSecondary,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "English",
                      style: TextStyle(color: textSecondary),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: textSecondary),
                  ],
                ),
              ),
              SizedBox(height: 2),
              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.accessibility_new,
                iconColor: n1,
                title: "Accessibility Tools",
                subtitle: "Accessibility options",
                titleColor: textPrimary,
                subtitleColor: textSecondary,
                trailing: const Icon(Icons.chevron_right, color: textSecondary),
              ),

              const SizedBox(height: 12),

              const Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),

              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.feedback,
                iconColor: n1,
                title: "Feedback",
                titleColor: textPrimary,
                subtitleColor: textSecondary,
                trailing: const Icon(Icons.chevron_right, color: textSecondary),
              ),
              SizedBox(height: 2),
              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.phone,
                iconColor: n1,
                title: "Contact Us",
                titleColor: textPrimary,
                subtitleColor: textSecondary,
                trailing: const Icon(Icons.chevron_right, color: textSecondary),
              ),
              SizedBox(height: 2),

              /// ===== Logout =====
              SettingCard(
                background: AppColors.dialogcolor,
                icon: Icons.logout,
                iconColor: Colors.redAccent,
                title: "Logout",
                titleColor: Colors.redAccent,
                subtitleColor: textSecondary,
                flipIcon: true,
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),

              /// ⬇️ هذا بيثبّت كلشي لفوق
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= Setting Card =================
class SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  final Color background;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;
  final bool flipIcon;

  const SettingCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.background,
    required this.iconColor,
    required this.titleColor,
    required this.subtitleColor,
    this.flipIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.04),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.rotate(
              angle: flipIcon ? math.pi : 0,
              child: Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                )
              : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
