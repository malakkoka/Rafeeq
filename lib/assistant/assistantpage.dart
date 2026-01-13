// ignore_for_file: unused_element, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:front/assistant/assistanceRequestPage.dart';
import 'package:front/color.dart';
import 'package:front/constats.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  bool isLoading = false;
  bool atHome = true;

  /// لاحقًا من الباك
  String assistedUserName = 'Ahmad Mohsin';

  List<Map<String, String>> recentRequests = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // ================== API LOGIC ==================

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
    final response = await http.delete(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      _refreshData();
    }
  }

  Future<void> _archivePost(String postId) async {
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
          // نمرر البيانات
          postId: request['id'],
          initialContent: request['content'], isEdit: true,
        ),
      ),
    ).then((_) => _refreshData());
  }

  // user interface

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Patient',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 16),
                  _buildPatientStatusCard(),
                  const SizedBox(height: 32),
                  const Text(
                    'Recent Help Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...recentRequests.map(_buildRequestCard).toList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  // ================== WIDGETS ==================

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundImage: AssetImage('images/OIP.webp'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 14, color: AppColors.n1),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assistedUserName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.n1.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Blind User',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Location
            Row(
              children: const [
                Icon(Icons.location_on, color: AppColors.n1),
                SizedBox(width: 8),
                Text('Location: Home'),
              ],
            ),
            const SizedBox(height: 10),

            // Map preview (placeholder)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 100,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.map, size: 30, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // At home toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.home, color: AppColors.n1),
                    SizedBox(width: 8),
                    Text('At home'),
                  ],
                ),
                /* Switch(

                  value: atHome,
                  activeColor: AppColors.n10,
                  onChanged: (value) {
                    setState(() => atHome = value);
                  },
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, String> request) {
    return Card(
      color: AppColors.dialogcolor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request['content']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  _buildStatusChip(request['status']!),
                ],
              ),
            ),
            Row(
              children: [
                // ✏️ Edit (بس Pending)
                if (request['status'] == 'Pending')
                  Tooltip(
                    message: 'Edit request',
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: Colors.blueGrey,
                      onPressed: () {
                        // edit logic
                      },
                    ),
                  ),

                // 🗑 Delete / 📦 Archive
                Tooltip(
                  message: request['status'] == 'Pending'
                      ? 'Delete request'
                      : 'Archive request',
                  child: IconButton(
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == 'Completed'
        ? Colors.green
        : status == 'Accepted'
            ? Colors.blue
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ================== FETCH DATA ==================

  Future<void> _refreshData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/account/posts/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      setState(() {
        recentRequests = data.map<Map<String, String>>((item) {
          return {
            'id': item['id'].toString(),
            'content': item['content'] ?? 'No title',
            'status': _mapStateToStatus(item['state']),
          };
        }).toList();
      });
    }
  }
}

// ================== HELPERS ==================

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
