import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_state_badge.dart';
import 'package:front/color.dart';



class PostCard extends StatelessWidget {
  final Post post;
  
  const PostCard({super.key, required this.post,});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.inputField,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary),
            ),
            SizedBox(height: 6),
            Text(
              post.content,
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                
                buildStateBadge(post.state ?? 0),
                Spacer(),
                Text(
                  "Author: Wala'a",
                  style: TextStyle(
                      fontSize: 14.5,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400),
                ), //Text("Author: ${post.author}"),
                Spacer(flex: 2),
              ],
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Text(
                      formatTimeAgoEn(post.created_at),
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.accent)),
                        onPressed: () {
                          ShowConfirmDialog(context);
                        },
                        child: Text(
                          "I can help",
                        )),
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

void ShowConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      //icon: Icon(Icons.add_to_photos_sharp),
      backgroundColor: AppColors.dialogcolor,
      title: Center(
        child: const Text(
          "Ready to help?",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
        ),
      ),
      content: const Text(
        "Are you sure you want help this person?",
        style: TextStyle(
          color: AppColors.primary,
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
                      const Color.fromARGB(255, 230, 226, 220))),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "  Cancel  ",
                style: TextStyle(color: Color.fromARGB(255, 120, 120, 120)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 52, 132, 145))),
              onPressed: () {
                Navigator.pop(
                    context); ///////////////............. انتبهيلها .............
                //هون بعدين رح استدعي ال endpoint تبع المساعدة
              },
              child: const Text(
                "Yes, I'll help",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

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
