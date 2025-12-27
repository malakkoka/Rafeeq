// ignore_for_file: unused_element, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:front/assistant/assistanceRequestPage.dart';
import 'package:front/color.dart';
import 'package:front/component/customdrawer.dart';
import 'package:front/constats.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _handleDelete(Map<String, String> request) async {
    final status = request['status'];
    final postId = request['id'];

    if (postId == null) return;

    // 🟠 Pending → حذف فعلي
    if (status == 'Pending') {
      await _deletePostHard(postId);
    }

    // 🔵 Accepted / Completed → حذف شكلي
    else if (status == 'Accepted' || status == 'Completed') {
      await _archivePost(postId);
    }
  }

  Future<void> _deletePostHard(String postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {
        'Authorization':
            'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      _refreshData();
    }
  }

  Future<void> _archivePost(String postId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {
        'Authorization':
            'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'state': 3, // Archived
      }),
    );

    if (response.statusCode == 200) {
      _refreshData();
    }
  }

  void _goToEditRequest(Map<String, String> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssistanceRequestPage(
          // نمرر البيانات
          postId: request['id'],
          initialContent: request['content'],
          isEdit: true,
        ),
      ),
    ).then((_) => _refreshData());
  }

  /// هدول بعدين حعدلعم واجيبهم من الباك
  String assistedUserName = 'Ahmad';
  String assistedUserStatus = 'Needs support';

  List<Map<String, String>> recentRequests = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: AppColors.dialogcolor,
      appBar: AppBar(
        backgroundColor: AppColors.dialogcolor,
        title: const Text(
          'Assistance Dashboard',
        ),
        centerTitle: true,
      ),
      
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                children: [
                  Text(
                    'Assisted User: $assistedUserName',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assistedUserStatus,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      onPressed: _goToCreateRequest,
                      child: const Text(
                        'Ask for help',
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Recent help requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recentRequests.map((request) {
                    return Card(
                      color: AppColors.background,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 أيقونة الحالة
                            Icon(
                              request['status'] == 'Completed'
                                  ? Icons.check_circle
                                  : request['status'] == 'Accepted'
                                      ? Icons.handshake
                                      : Icons.hourglass_bottom,
                              color: request['status'] == 'Completed'
                                  ? Colors.green
                                  : request['status'] == 'Accepted'
                                      ? Colors.blue
                                      : Colors.orange,
                              size: 28,
                            ),

                            const SizedBox(width: 12),

                            // 🔹 النص + الحالة
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['content']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // الحالة
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: request['status'] == 'Completed'
                                          ? Colors.green.withOpacity(0.12)
                                          : request['status'] == 'Accepted'
                                              ? Colors.blue.withOpacity(0.12)
                                              : Colors.orange.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      request['status']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: request['status'] == 'Completed'
                                            ? Colors.green
                                            : request['status'] == 'Accepted'
                                                ? Colors.blue
                                                : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔹 أيقونات الأكشن
                            Row(
                              children: [
                                // Edit (بس Pending)
                                if (request['status'] == 'Pending')
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20),
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      // edit logic
                                    },
                                  ),

                                // Delete / Archive
                                IconButton(
                                  icon: Icon(
                                    request['status'] == 'Pending'
                                        ? Icons.delete_outline
                                        : Icons.archive_outlined,
                                    size: 20,
                                  ),
                                  color: request['status'] == 'Pending'
                                      ? Colors.redAccent
                                      : Colors.grey,
                                  onPressed: () => _handleDelete(request),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }

  void _goToCreateRequest() {
    // 🔹 فتح صفحة إنشاء طلب مساعدة
    // 🔹 عند الإرسال → ينحفظ بالباك
    // 🔹 ويظهر لاحقًا عند المتطوع
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AssistanceRequestPage(),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/posts/'),
      headers: {
        'Authorization':
            'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      setState(() {
        recentRequests = data.map<Map<String, String>>((item) {
          return {
            'id': item['id'].toString(), // ✅ مهم للحذف
            'content': item['content'] ?? 'No title',
            'status': _mapStateToStatus(item['state']),
          };
        }).toList();
      });
    }

    setState(() => isLoading = false);
  }
}

String _mapStateToStatus(dynamic state) {
  switch (state) {
    case 0:
      return 'Pending';
    case 1:
      return 'Accepted';
    case 2:
      return 'Completed';
    default:
      return 'Unknown';
  }
}
