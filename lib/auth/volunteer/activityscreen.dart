import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/post_card.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_state_badge.dart';
import 'package:front/color.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;

class VolunteerActivityScreen extends StatefulWidget {
  const VolunteerActivityScreen({super.key});

  @override
  _VolunteerActivityScreenState createState() =>
      _VolunteerActivityScreenState();
}

class _VolunteerActivityScreenState extends State<VolunteerActivityScreen> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPendingApprovalPosts(); // جلب البوستات التي حالتها Pending Approval (حالة 3)
  }

  Future<List<Post>> fetchPendingApprovalPosts() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/account/posts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Post> filteredPosts = data
          .map((post) => Post.fromJson(post))
          .where((post) => post.state == 3) // فلترة حسب الحالة 3
          .toList();
      return filteredPosts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Activity",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // أثناء تحميل البيانات
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // في حالة حدوث خطأ
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pending posts available.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index]; // جلب البوست في كل مرة
                return CustomPostCard(post: post);
              },
            );
          }
        },
      ),
    );
  }
}

class CustomPostCard extends StatelessWidget {
  final Post post;

  const CustomPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final String city = post.city;
    final String serviceType = post.title;
    final String patientType = getPatientTypeFromPost(post);
    final String authorName = cleanAuthorName(post.author);

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: AppColors.inputField,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== العنوان والنصوص ========== 
            Text(
              serviceType,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "by $authorName",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 12),
            Text(
              post.content,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            // ========== الموقع والزمن ========== 
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                SizedBox(width: 6),
                Text(
                  city,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Spacer(),
                Text(
                  formatTimeAgoEn(post.created_at),
                  style: TextStyle(fontSize: 12.5, color: Colors.black38),
                ),
              ],
            ),
            SizedBox(height: 12),
            // ========== حالة البوست ========== 
            buildStateBadge(post.state ?? 0),
          ],
        ),
      ),
    );
  }
}
