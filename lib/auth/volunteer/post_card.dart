import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/activityscreen.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_state_badge.dart';
import 'package:front/color.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
    required String postId,
  });

  @override
  Widget build(BuildContext context) {
    final String city = post.city;
    final String serviceType = post.title;
    final String patientType = getPatientTypeFromPost(post);
    final String authorName = cleanAuthorName(post.author);

    return Card(
      color: AppColors.inputField,
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceType,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      _softChip(
                        getPatientIcon(patientType),
                        patientType,
                        Colors.orange,
                      ),
                      SizedBox(height: 8),
                      /*Text(
                        "by $authorName",
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black45,
                        ),
                      ),*/
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    getImageByPatientType(patientType),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 17,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        size: 15, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(city, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                buildStateBadge(post.state ?? 0),
                const SizedBox(width: 10),
                const Spacer(),
                if (post.state == 0) // إذا كانت الحالة Pending
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () async {
                        final bool? confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              /*title: const Text(
                                'Confirm Help',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),*/
                              content: const Text(
                                'Are you sure you want to help?',
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed == true) {
                          await sendHelpRequest(post.id!); // تحديث الحالة

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerActivityScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "I can help",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer_sharp, size: 14, color: Colors.black45),
                const SizedBox(width: 3),
                Text(
                  formatTimeAgoEn(post.created_at),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _softChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// دالة لتحديث حالة البوست
Future<void> sendHelpRequest(int postId) async {
  final token = await TokenService.getToken();
  await updatePostState(postId, 3); // 3 تعني في انتظار موافقة المساعد

  final response = await http.post(
    Uri.parse('$baseUrl/api/account/posts/$postId/request-help/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to send help request');
  }
}

// دالة لتحديث حالة البوست
Future<void> updatePostState(int postId, int state) async {
  final token = await TokenService.getToken();

  final response = await http.patch(
    Uri.parse('$baseUrl/api/account/posts/$postId/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'state': state,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to update post state');
  }
}

String cleanAuthorName(String raw) {
  return raw.replaceAll(
    RegExp(r'\s*-\s*assistant', caseSensitive: false),
    '',
  );
}

String getPatientTypeFromPost(Post post) {
  if (post.id == null) return 'Unknown';
  return post.id! % 2 == 0 ? 'Visually Impaired' : 'Hearing Impaired';
}

IconData getPatientIcon(String type) {
  switch (type) {
    case 'Visually Impaired':
      return Icons.visibility_off;
    case 'Hearing Impaired':
      return Icons.hearing_disabled;
    default:
      return Icons.person;
  }
}

String getImageByPatientType(String patientType) {
  switch (patientType) {
    case 'Hearing Impaired':
      return 'images/sign_language.png';
    case 'Visually Impaired':
      return 'images/blind.png';
    default:
      return 'images/sign_language.png';
  }
}

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
