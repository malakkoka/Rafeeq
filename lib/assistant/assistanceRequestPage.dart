// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/assistant/selectLocationPage.dart';
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

//Location
  String? selectedLocationLabel; // مثال: "Amman - Abdoun, Building 12"
  double? selectedLat;
  double? selectedLng; // هيك صار عندي اسم المكان واللحداثيات

//Date&Time
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedDateTimeLabel = 'Select date & time';

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

  Future<void> _pickDateTime() async {
    //  اختيار التاريخ
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) return;

    //  اختيار الوقت
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDate = pickedDate;
      selectedTime = pickedTime;
      selectedDateTimeLabel =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} - ${pickedTime.format(context)}';
    });
  }

  Future<void> _submitRequest() async {
    setState(() => isSubmitting = true);

    /// Validation
    if (patientCondition.isEmpty) {
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

    //Location validation
    if (selectedLat == null || selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the location of the patient'),
        ),
      );
      setState(() => isSubmitting = false);
      return;
    }

    // Date&Time validation
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time for assistance'),
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

    /// BODY (مشترك بين Create و Edit)
    final body = {
      "title": "Assistance Request",
      "content": "Patient Condition: $patientCondition\n"
          "Type: $typesText\n"
          "Location: $selectedLocationLabel\n"
          "Date & Time: $selectedDateTimeLabel\n"
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

            const SizedBox(height: 10),

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

            const SizedBox(height: 10),

            /// Location
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Location'),
                  const SizedBox(height: 8),

                  // Preview صغير إذا اختار لوكيشن
                  if (selectedLocationLabel != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedLocationLabel!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectLocationPage(),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            selectedLat = result['lat'];
                            selectedLng = result['lng'];
                            selectedLocationLabel =
                                'Lat: ${selectedLat!.toStringAsFixed(5)}, '
                                'Lng: ${selectedLng!.toStringAsFixed(5)}';
                          });
                        }

                        setState(() {
                          selectedLocationLabel = "Location not selected yet";
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Next step: open map to pick location'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: Text(
                        selectedLocationLabel == null
                            ? "Select Location"
                            : "Change Location",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Date & Time of Assistance'),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      selectedDateTimeLabel,
                      style: TextStyle(
                        color:
                            selectedDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: _pickDateTime,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Notes
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Additional Notes'),
                  TextField(
                    controller: notesController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Enter any important details...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
