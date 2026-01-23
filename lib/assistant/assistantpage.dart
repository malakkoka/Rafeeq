// ignore_for_file: unused_element, unnecessary_to_list_in_spreads

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/assistant/assistanceRequestPage.dart';
import 'package:front/assistant/post_volunteers_page.dart';
import 'package:front/color.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  bool isLoading = false;

  Map<String, dynamic>? patient;

  List<Map<String, String>> recentRequests = [];

  @override
  void initState() {
    super.initState();
    _loadPatientFromStorage();
    _refreshData();
  }

  Future<void> _loadPatientFromStorage() async {
    final user = await TokenService.getUser();

    if (!mounted) return;

    setState(() {
      if (user != null && user['patient'] != null) {
        patient = user['patient'];
      } else {
        patient = null;
      }
    });
  }

  Future<void> _handleDelete(Map<String, String> request) async {
    final status = request['status'];
    final postId = request['id'];

    if (postId == null) return;

    if (status == 'Pending') {
      await _deletePostHard(postId);
    } else if (status == 'Accepted' || status == 'Completed') {
      await _archivePost(postId);
    }
  }

  Future<void> _deletePostHard(String postId) async {
    final token = await TokenService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      _refreshData();
    }
  }

  Future<void> _archivePost(String postId) async {
    final token = await TokenService.getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'state': 3}),
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
          postId: request['id'],
          initialContent: request['content'],
          isEdit: true,
        ),
      ),
    ).then((_) => _refreshData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Patient',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: patient == null
          ? const Center(child: Text('No patient assigned'))
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 16),
                      _buildPatientStatusCard(),
                      const SizedBox(height: 32),
                      const Text(
                        'Recent Help Requests',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 90),
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: recentRequests.length,
                        itemBuilder: (context, index) {
                          return _buildRequestCard(recentRequests[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  //WIDGETS

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('images/deafpic.webp'),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient?['username'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.n1.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                patient?['user_type'] == 'blind' ? 'Blind User' : 'Deaf User',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientStatusCard() {
    return Card(
      color: AppColors.dialogcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.n1),
                SizedBox(width: 8),
                Text('Location: Home'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //SORT

  void _sortRequests() {
    const order = {'Pending': 0, 'Accepted': 1, 'Completed': 2};

    recentRequests.sort((a, b) {
      final aOrder = order[a['status']] ?? 3;
      final bOrder = order[b['status']] ?? 3;
      return aOrder.compareTo(bOrder);
    });
  }

  //FETCH POSTS

  Future<void> _refreshData() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/posts/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      if (!mounted) return;

      setState(() {
        recentRequests = data
            .map<Map<String, String>>((item) => {
                  'id': item['id'].toString(),
                  'type': item['assistance_type'] ?? '',
                  'content': item['content'] ?? '',
                  'notes': item['notes'] ?? '',
                  'date': item['scheduled_at'] ?? '',
                  'status': _mapStateToStatus(item['state']),
                  'volunteersCount': (item['help_requesters_ids'] as List?)
                          ?.length
                          .toString() ??
                      '0',
                }
                )
            .toList();
        _sortRequests();
      });
    }
  }

  // HELPERS

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

  String formatDateTime(String iso) {
    if (iso.isEmpty) return '';
    final dt = DateTime.parse(iso).toLocal();
    return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _extractLine(String content, String key) {
    final lines = content.split('\n');
    try {
      return lines
          .firstWhere((line) => line.startsWith('$key:'))
          .replaceFirst('$key:', '')
          .trim();
    } catch (_) {
      return '';
    }
  }

  Widget _buildRequestCard(Map<String, String> request) {
    final int volunteers = int.tryParse(request['volunteersCount'] ?? '0') ?? 0;

    final status = request['status'] ?? 'Pending';
    final color = _statusColor(status);

    final title = request['type'] ?? 'Help Request'; // نعرض النوع كعنوان
    final dateTime = request['scheduled_at'] != null
        ? formatDateTime(request['scheduled_at']!)
        : ''; // عرض التاريخ
    final createdAt = request['created_at'] != null
        ? formatDateTime(request['created_at']!)
        : 'Not Available'; // تاريخ الإنشاء
    final content = request['content'] ?? '';
    final notes = request['notes'] ?? '';
 
    return Card(
        color: AppColors.dialogcolor,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(_statusIcon(status), color: color, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title, // عرض النوع كعنوان
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          if (dateTime.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            _buildInfoRow(Icons.schedule, dateTime),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (status == 'Pending' && volunteers > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PostVolunteersPage(postId: request['id']!),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _buildStatusChip(status),
                          if (status == 'Pending' && volunteers > 0)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                width: 18,
                                height: 18,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  volunteers.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                if (dateTime.isNotEmpty)
                  _buildInfoRow(Icons.schedule, dateTime),

                if (notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      notes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                if (content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                /// ===== NOTES =====
                if (notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      notes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                /// ===== ACTIONS =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == 'Pending')
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _goToEditRequest(request),
                      ),
                    if (status == 'Pending')
                      IconButton(
                        icon: const Icon(Icons.people_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostVolunteersPage(
                                postId: request['id']!,
                              ),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        status == 'Pending'
                            ? Icons.delete_outline
                            : Icons.archive_outlined,
                      ),
                      onPressed: () => _handleDelete(request),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget _buildInfoRow(IconData icon, String text) {
    if (text.isEmpty || text == 'null') return const SizedBox();
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Accepted':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'Accepted':
        return Icons.handshake;
      default:
        return Icons.hourglass_bottom;
    }
  }
}
