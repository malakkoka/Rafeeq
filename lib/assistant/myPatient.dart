// ignore_for_file: unused_element, unnecessary_to_list_in_spreads, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/assistant/assistanceRequestPage.dart';
import 'package:front/assistant/post_volunteers_page.dart';
import 'package:front/color.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

class MyPatient extends StatefulWidget {
  const MyPatient({super.key});

  @override
  State<MyPatient> createState() => _MyPatientState();
}

Future<String> getAddressFromLatLng(String location) async {
  try {
    final parts = location.split(',');
    final double lat = double.parse(parts[0]);
    final double lng = double.parse(parts[1]);

    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      return [
        place.street,
        place.locality,
        place.administrativeArea,
      ].where((e) => e != null && e!.isNotEmpty).join(', ');
    }
  } catch (e) {
    debugPrint('Geocoding error: $e');
  }

  return 'Location not available';
}

class _MyPatientState extends State<MyPatient> {
  bool isLoading = false;
  Map<String, dynamic>? patientApi;
  Map<String, dynamic>? patient;
  List<Map<String, String>> recentRequests = [];

  @override
  void initState() {
    super.initState();
    _loadPatientFromStorage();
    _loadPatientFromApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshData();
    });
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

  // ================= DELETE / ARCHIVE =================

  Future<void> _handleDelete(Map<String, String> request) async {
    final state = request['state'];
    final postId = request['id'];

    if (postId == null) return;

    if (state == 'Pending' || state == 'Pending Approval') {
      await _deletePostHard(postId);
    } else if (state == 'Accepted' ||
        state == 'In Progress' ||
        state == 'Completed') {
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
    ).then((_) {
      if (!mounted) return;
      _refreshData();
    });
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

  // ================= WIDGETS =================

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
    final String currentLocation =
        patientApi?['current_location'] ?? 'Location not available';

    final bool inHome = patientApi?['in_home'] ?? false;
    final Color statusColor = inHome ? Colors.green : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Icon(Icons.my_location, size: 18, color: Colors.grey),
    const SizedBox(width: 8),
    Expanded(
      child: SelectableText(
        currentLocation,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.black54,
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.copy, size: 18),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: currentLocation));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location copied')),
        );
      },
    ),
  ],
),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    inHome ? Icons.home_outlined : Icons.directions_walk,
                    size: 17,
                    color: statusColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    inHome ? 'At Home' : 'Not At Home',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DATA =================

  void _sortRequests() {
    const order = {'Pending': 0, 'Accepted': 1, 'Completed': 2};
    recentRequests.sort((a, b) {
      final aOrder = order[a['state']] ?? 3;
      final bOrder = order[b['state']] ?? 3;
      return aOrder.compareTo(bOrder);
    });
  }

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
                  'title': item['title'] ?? '',
                  'content': item['content'] ?? '',
                  'created_at': item['created_at'] ?? '',
                  'state': _mapStateToStatus(item['state']),
                })
            .toList();
        _sortRequests();
      });
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
      case 3:
        return 'Pending Approval';
      case 4:
        return 'In Progress';
      default:
        return 'Unknown';
    }
  }

  String formatDateTime(String iso) {
    if (iso.isEmpty) return '';
    final dt = DateTime.parse(iso).toLocal();
    return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // ================= CARD =================

  Widget _buildRequestCard(Map<String, String> request) {
    final _state = request['state'] ?? 'Pending';

    final bool canEdit = _state == 'Pending' || _state == 'Pending Approval';

    final bool canArchive = _state == 'Accepted' ||
        _state == 'In Progress' ||
        _state == 'Completed';

    final _color = _statusColor(_state);
    final _title = request['title'] ?? 'Help Request';
    final createdDate = request['created_at'] != null
        ? formatDateTime(request['created_at']!)
        : '';

    final _notes = request['content'] ?? '';

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
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: _color.withOpacity(0.15),
                  child: Icon(_statusIcon(_state), color: _color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _title,
                    style: const TextStyle(
                        fontSize: 15.5, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
  children: [
    _buildStatusChip(_state),
    const SizedBox(width: 8),
    _buildQuickActionChip(_state, request['id']!),
  ],
),

              ],
            ),
            const SizedBox(height: 8),
            if (_notes.isNotEmpty)
              Text(
                _notes,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            const SizedBox(height: 10),
            if (createdDate.isNotEmpty)
              _buildInfoRow(Icons.schedule, createdDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canEdit)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _goToEditRequest(request),
                  ),
                if (canEdit)
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
                if (canEdit || canArchive)
                  IconButton(
                    icon: Icon(
                      canEdit ? Icons.delete_outline : Icons.archive_outlined,
                    ),
                    onPressed: () => _handleDelete(request),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
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

  Future<void> _loadPatientFromApi() async {
    final token = await TokenService.getToken();
    final user = await TokenService.getUser();
    if (user == null) return;

    final int patientId = user['patient']['id'];

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/users/$patientId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 && mounted) {
      setState(() {
        patientApi = jsonDecode(response.body);
      });
    }
  }

  Future<void> _updatePostState(String postId, int newState) async {
    final token = await TokenService.getToken();

    final response = await http.patch(
      Uri.parse('$baseUrl/api/account/posts/$postId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'state': newState}),
    );

    if (response.statusCode == 200) {
      _refreshData();
    }
  }

  Widget _buildQuickActionChip(String status, String postId) {
    if (status == 'Accepted') {
      return _actionChip(
        label: 'Start',
        color: Colors.blue,
        icon: Icons.play_arrow_rounded,
        onTap: () => _updatePostState(postId, 4), // In Progress
      );
    }

    if (status == 'In Progress') {
      return _actionChip(
        label: 'Done',
        color: Colors.green,
        icon: Icons.check_rounded,
        onTap: () => _updatePostState(postId, 2), // Completed
      );
    }

    return const SizedBox.shrink();
  }

  Widget _actionChip({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
