import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_service.dart';
import 'package:front/auth/volunteer/post_card.dart';
import 'package:front/color.dart';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  State<VolunteerHome> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  late Future<List<Post>> futurePosts;

  String selectedStatus = 'All';
  bool newestFirst = true;

  @override
  void initState() {
    super.initState();
    futurePosts = PostService.getPosts();
  }

  

  // ===== Apply filters =====
  List<Post> _applyFilters(List<Post> posts) {
    List<Post> filtered = posts;

    if (selectedStatus != 'All') {
      filtered = filtered
          .where((p) => _mapStateToStatus(p.state) == selectedStatus)
          .toList();
    }

    filtered.sort((a, b) => newestFirst
        ? b.created_at.compareTo(a.created_at)
        : a.created_at.compareTo(b.created_at));

    return filtered;
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
          "Help Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No requests available'),
            );
          }

          final filteredPosts = _applyFilters(snapshot.data!);

          if (filteredPosts.isEmpty) {
            return const Center(
              child: Text('No requests match your filters'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              80, // 👈 قدّ الـ Bottom Navigation فقط
            ),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PostCard(post: filteredPosts[index], postId: filteredPosts[index].id.toString()),
              );
            },
          );
        },
      ),
    );
  }
}

/// ===== Utils =====
String _mapStateToStatus(int? state) {
  switch (state) {
    case 0:
      return 'Pending';
    case 1:
      return 'Accepted';
    default:
      return 'All';
  }
}

