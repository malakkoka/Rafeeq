/*// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/constats.dart';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';

class AssistanceRequestPage extends StatefulWidget {
  final String? postId;
  final String? initialContent;
  final bool isEdit;

  const AssistanceRequestPage({
    super.key,
    this.postId,
    this.initialContent,
    this.isEdit = false,
  });

  @override
  State<AssistanceRequestPage> createState() => _AssistanceRequestPageState();
}

class _AssistanceRequestPageState extends State<AssistanceRequestPage> {
  /// Variables
  String selectedReason = '';
  List<String> selectedTypes = [];
  String patientCondition = '';

  TextEditingController notesController = TextEditingController();
  TextEditingController otherTypeController = TextEditingController();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // إذا Edit → نعبي الملاحظات
    if (widget.isEdit && widget.initialContent != null) {
      notesController.text = widget.initialContent!;
    }
  }

  /// Submit (Create أو Edit)
  Future<void> _submitRequest() async {
    setState(() => isSubmitting = true);

    if (patientCondition.isEmpty || selectedReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );

      setState(() => isSubmitting = false);
      return;
    }
    if (selectedTypes.contains('Other') &&
        otherTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify the assistance type')),
      );

      setState(() => isSubmitting = false);
      return;
    }

    if (selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select at least one assistance type')),
      );
      setState(() => isSubmitting = false);
      return;
    }
    final typesText = selectedTypes.contains('Other')
        ? [
            ...selectedTypes.where((t) => t != 'Other'),
            otherTypeController.text
          ].join(', ')
        : selectedTypes.join(', ');

    final body = {
      "content": "Patient Condition: $patientCondition\n"
          "Reason: $selectedReason\n"
          "Type: $typesText\n"
          "Notes: ${notesController.text}",
      "state": 0
    };

    try {
      final response = widget.isEdit
          ? await http.patch(
              Uri.parse('$baseUrl/api/account/posts/${widget.postId}/'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(body),
            )
          : await http.post(
              Uri.parse('$baseUrl/api/account/post/create/'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                ...body,
                "title": "Assistance Request",
                "state": 0,
              }),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Submit error: $e');
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.isEdit ? 'Edit Request' : 'Assistance Request'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Patient Condition
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Patient Condition'),
                  RadioListTile(
                    title: const Text('Visually Impaired'),
                    value: 'Visually Impaired',
                    groupValue: patientCondition,
                    onChanged: (v) => setState(() => patientCondition = v!),
                  ),
                  RadioListTile(
                    title: const Text('Hearing Impaired'),
                    value: 'Hearing Impaired',
                    groupValue: patientCondition,
                    onChanged: (v) => setState(() => patientCondition = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Reason
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Reason for Assistance'),
                  RadioListTile(
                    title: const Text('Urgent Situation'),
                    value: 'Urgent Situation',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                  RadioListTile(
                    title: const Text('Unavailable Currently'),
                    value: 'Unavailable Currently',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                  RadioListTile(
                    title: const Text('Need Additional Support'),
                    value: 'Need Additional Support',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Type
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Type of Assistance'),
                  CheckboxListTile(
                    title: const Text('Companion Support'),
                    value: selectedTypes.contains('Companion Support'),
                    onChanged: (v) {
                      setState(() {
                        v!
                            ? selectedTypes.add('Companion Support')
                            : selectedTypes.remove('Companion Support');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reading/Writing Help'),
                    value: selectedTypes.contains('Reading/Writing Help'),
                    onChanged: (v) {
                      setState(() {
                        v!
                            ? selectedTypes.add('Reading/Writing Help')
                            : selectedTypes.remove('Reading/Writing Help');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Other'),
                    value: selectedTypes.contains('Other'),
                    onChanged: (value) {
                      setState(() {
                        value!
                            ? selectedTypes.add('Other')
                            : selectedTypes.remove('Other');
                      });
                    },
                  ),
                ],
              ),
            ),
            if (selectedTypes.contains('Other'))
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: TextField(
                  controller: otherTypeController,
                  decoration: const InputDecoration(
                    hintText: 'Please specify the type of assistance',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            /// Notes
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Additional Notes'),
                  TextField(
                    controller: notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter any important details...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                ),
                onPressed: isSubmitting ? null : _submitRequest,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.isEdit ? 'Save Changes' : 'Submit Request',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      color: AppColors.dialogcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
*/

// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/constats.dart';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';

class AssistanceRequestPage extends StatefulWidget {
  final String? postId;
  final String? initialContent;
  final bool isEdit;

  const AssistanceRequestPage({
    super.key,
    this.postId,
    this.initialContent,
    this.isEdit = false,
  });

  @override
  State<AssistanceRequestPage> createState() => _AssistanceRequestPageState();
}

class _AssistanceRequestPageState extends State<AssistanceRequestPage> {
  String selectedReason = '';
  List<String> selectedTypes = [];
  String patientCondition = '';

  TextEditingController notesController = TextEditingController();
  TextEditingController otherTypeController = TextEditingController();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.initialContent != null) {
      notesController.text = widget.initialContent!;
    }
  }

  Future<void> _submitRequest() async {
    setState(() => isSubmitting = true);

    /// Validation
    if (patientCondition.isEmpty || selectedReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      setState(() => isSubmitting = false);
      return;
    }

    if (selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one assistance type'),
        ),
      );
      setState(() => isSubmitting = false);
      return;
    }

    if (selectedTypes.contains('Other') &&
        otherTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify the assistance type')),
      );
      setState(() => isSubmitting = false);
      return;
    }

    final typesText = selectedTypes.contains('Other')
        ? [
            ...selectedTypes.where((t) => t != 'Other'),
            otherTypeController.text.trim(),
          ].join(', ')
        : selectedTypes.join(', ');

    /// ✅ BODY (مشترك بين Create و Edit)
    final body = {
      "title": "Assistance Request",
      "content":
          "Patient Condition: $patientCondition\n"
          "Reason: $selectedReason\n"
          "Type: $typesText\n"
          "Notes: ${notesController.text}",
      "state": 0,
    };

    try {
      final response = widget.isEdit
          ? await http.patch(
              Uri.parse('$baseUrl/api/account/posts/${widget.postId}/'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(body),
            )
          : await http.post(
              Uri.parse('$baseUrl/api/account/post/create/'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(body),
            );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Submit error: $e');
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.isEdit ? 'Edit Request' : 'Assistance Request'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Patient Condition
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Patient Condition'),
                  RadioListTile(
                    title: const Text('Visually Impaired'),
                    value: 'Visually Impaired',
                    groupValue: patientCondition,
                    onChanged: (v) => setState(() => patientCondition = v!),
                  ),
                  RadioListTile(
                    title: const Text('Hearing Impaired'),
                    value: 'Hearing Impaired',
                    groupValue: patientCondition,
                    onChanged: (v) => setState(() => patientCondition = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Reason
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Reason for Assistance'),
                  RadioListTile(
                    title: const Text('Urgent Situation'),
                    value: 'Urgent Situation',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                  RadioListTile(
                    title: const Text('Unavailable Currently'),
                    value: 'Unavailable Currently',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                  RadioListTile(
                    title: const Text('Need Additional Support'),
                    value: 'Need Additional Support',
                    groupValue: selectedReason,
                    onChanged: (v) => setState(() => selectedReason = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Type
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Type of Assistance'),
                  CheckboxListTile(
                    title: const Text('Companion Support'),
                    value: selectedTypes.contains('Companion Support'),
                    onChanged: (v) {
                      setState(() {
                        v!
                            ? selectedTypes.add('Companion Support')
                            : selectedTypes.remove('Companion Support');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reading/Writing Help'),
                    value: selectedTypes.contains('Reading/Writing Help'),
                    onChanged: (v) {
                      setState(() {
                        v!
                            ? selectedTypes.add('Reading/Writing Help')
                            : selectedTypes.remove('Reading/Writing Help');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Other'),
                    value: selectedTypes.contains('Other'),
                    onChanged: (v) {
                      setState(() {
                        v!
                            ? selectedTypes.add('Other')
                            : selectedTypes.remove('Other');
                      });
                    },
                  ),
                ],
              ),
            ),

            if (selectedTypes.contains('Other'))
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: TextField(
                  controller: otherTypeController,
                  decoration: const InputDecoration(
                    hintText: 'Please specify the type of assistance',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            /// Notes
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Additional Notes'),
                  TextField(
                    controller: notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter any important details...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                ),
                onPressed: isSubmitting ? null : _submitRequest,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.isEdit ? 'Save Changes' : 'Submit Request',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      color: AppColors.dialogcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
