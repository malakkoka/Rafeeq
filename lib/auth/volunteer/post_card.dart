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
    return Card(
      color: AppColors.dialogcolor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            /// Content
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 14),

            /// State + Author
            Row(
              children: [
                buildStateBadge(post.state ?? 0),
                const Spacer(),
                const Text(
                  "Author: Wala'a",
                  style: TextStyle(fontSize: 13.5),
                ),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 12),

            /// Time + Action Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Text(
                      formatTimeAgoEn(post.created_at),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),

                    /// يظهر فقط إذا الحالة pending
                    if (post.state == 0)
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.accent,
                          ),
                        ),
                        onPressed: () {
                          ShowConfirmDialog(context);
                        },
                        child: const Text(
                          "I can help",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= CONFIRM DIALOG =================
void ShowConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.dialogcolor,
      title: const Center(
        child: Text(
          "Ready to help?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      content: const Text(
        "Are you sure you want help this person?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 230, 226, 220),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "  Cancel  ",
                style: TextStyle(
                  color: Color.fromARGB(255, 120, 120, 120),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 52, 132, 145),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                //  استدعاء endpoint تبع المساعدة
              },
              child: const Text(
                "Yes, I'll help",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// ================= TIME FORMAT =================
String formatTimeAgoEn(String dateString) {
  final DateTime createdAt = DateTime.parse(dateString);
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }
}
