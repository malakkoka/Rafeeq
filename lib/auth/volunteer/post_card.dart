import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_state_badge.dart';
import 'package:front/color.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    /// ===== TEMP DATA (UNTIL BACKEND) =====
    final String city = 'Amman'; //TODO: backend
    final String patientType = 'Deaf'; // TODO: backend
    final String serviceType = 'Sign Language'; // TODO: backend

    final String imagePath = 'images/sign_language.png';
    // TODO: change image based on patientTyp

    return Card(
      color: AppColors.inputField,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  const Text(
                    "Assistance Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// CHIPS
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _chip(Icons.sign_language, serviceType, Colors.blue),
                      _chip(
                        Icons.hearing_disabled,
                        patientType,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// CITY
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(city),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// DATE
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        post.created_at,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// STATUS + AUTHOR
                  Row(
                    children: [
                      buildStateBadge(post.state ?? 0),
                      const Spacer(),
                      const Text(
                        "Author: Wala'a",
                        // TODO: backend
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// TIME + BUTTON
                  Row(
                    children: [
                      Text(
                        formatTimeAgoEn(post.created_at),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      if (post.state == 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            showConfirmDialog(context);
                          },
                          child: const Text(
                            "I can help",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// ================= RIGHT IMAGE =================
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.22,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== CHIP WIDGET =====
  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= CONFIRM DIALOG =================
void showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ready to help?"),
      content: const Text("Are you sure you want help this person?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Yes, I'll help"),
        ),
      ],
    ),
  );
}

/// ================= TIME FORMAT =================
String formatTimeAgoEn(String dateString) {
  final DateTime createdAt = DateTime.parse(dateString);
  final Duration diff = DateTime.now().difference(createdAt);

  if (diff.inSeconds < 60) return "Just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
  if (diff.inHours < 24) return "${diff.inHours} hours ago";
  if (diff.inDays == 1) return "Yesterday";
  if (diff.inDays < 7) return "${diff.inDays} days ago";
  return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
}
