import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';

class PostVolunteersPage extends StatefulWidget {
  final String postId;

  const PostVolunteersPage({
    super.key,
    required this.postId,
  });

  @override
  State<PostVolunteersPage> createState() => _PostVolunteersPageState();
}

class _PostVolunteersPageState extends State<PostVolunteersPage> {
  bool isLoading = true;
  String postStatus = 'pending';
  List<Map<String, dynamic>> volunteers = [];

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  Future<void> _loadVolunteers() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/account/posts/${widget.postId}/'),


      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Map<String, dynamic>> parsedVolunteers =
          List<Map<String, dynamic>>.from(
        (data['help_requesters'] ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      if (!mounted) return;

      setState(() {
        volunteers = parsedVolunteers;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _assignVolunteer(int volunteerId) async {
    final token = await TokenService.getToken();
final url = '$baseUrl/api/account/posts/${widget.postId}/';
  print('URL: $url'); // طباعة الـ URL للتحقق من صحته

    // إرسال طلب لتعيين المتطوع
    final response = await http.patch(
      Uri.parse(
          '$baseUrl/api/account/posts/${widget.postId}/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'volunteer_id': volunteerId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // تحديث حالة الطلب إلى "accepted" بعد تعيين المتطوع
      final updateResponse = await http.patch(
        Uri.parse('$baseUrl/api/account/posts/${widget.postId}/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'state': 1, 
        }),
      );
   print('Response Status Code: ${updateResponse.statusCode}');
print('Response Body: ${updateResponse.body}');
      if (updateResponse.statusCode == 200 ||
          updateResponse.statusCode == 201) {
        // تحديث الحالة في الواجهة
        setState(() {
          postStatus = 'accepted'; //
          isLoading = false;
        });

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Volunteer has been assigned successfully and request status is now accepted!')),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to update request status. Please try again later.')),
        );
      }
    } else {
      print('Error: ${response.body}');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to assign volunteer. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Volunteers'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : volunteers.isEmpty
              ? const Center(child: Text('No volunteers yet'))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  itemCount: volunteers.length,
                  itemBuilder: (context, index) {
                    final v = volunteers[index];

                    final gender = v['gender'];
                    final canSign = v['can_speak_with_sign_language'] == true;

                    return Card(
                      color: AppColors.dialogcolor,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ===== HEADER =====
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      AppColors.n1.withOpacity(0.15),
                                  child: Icon(
                                    gender == 'female'
                                        ? Icons.female
                                        : Icons.male,
                                    color: AppColors.n1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    v['username'] ?? 'Volunteer',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () => _assignVolunteer(v['id']),
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            //INFO CHIPS
                            Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children: [
                                if (gender != null)
                                  _infoChip(
                                    icon: Icons.person,
                                    label: gender,
                                  ),
                                /* if (canWrite)
                                  _infoChip(
                                    icon: Icons.edit,
                                    label: 'Can Write',
                                    color: Colors.green,
                                  ),*/
                                if (canSign)
                                  _infoChip(
                                    icon: Icons.sign_language,
                                    label: 'Sign Language',
                                    color: Colors.blue,
                                  ),
                                /*if (inHome)
                                  _infoChip(
                                    icon: Icons.home,
                                    label: 'At Home',
                                    color: Colors.orange,
                                  ),*/
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

//INFO CHIP
Widget _infoChip({
  required IconData icon,
  required String label,
  Color color = Colors.grey,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
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
