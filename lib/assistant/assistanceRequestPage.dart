// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/assistant/mainNavBar.dart';
import 'package:front/assistant/selectLocationPage.dart';
import 'package:front/auth/call/incomming.dart';
import 'package:front/constats.dart';
import 'package:front/services/token_sevice.dart';
import 'package:http/http.dart' as http;
import 'package:front/color.dart';

import '../component/viewinfo.dart';

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
  String? selectedType;
  String? patientType; // blind / deaf

  /// LOCATION
  String? selectedLocationLabel;
  double? selectedLat;
  double? selectedLng;

  /// DATE & TIME
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedDateTimeLabel = 'Select date & time';

  /// CONTROLLERS
  final TextEditingController notesController = TextEditingController();
  final TextEditingController otherTypeController = TextEditingController();

  bool isSubmitting = false;

  List<Map<String, dynamic>> get assistanceTypes {
    if (patientType == 'blind') {
      return [
        {
          'icon': Icons.menu_book,
          'label': 'Reading',
          'value': 'Reading',
          'color': Colors.blue,
        },
        {
          'icon': Icons.map_outlined,
          'label': 'Navigation',
          'value': 'Navigation',
          'color': Colors.green,
        },
        {
          'icon': Icons.people,
          'label': 'Companion',
          'value': 'Companion',
          'color': Colors.orange,
        },
        {
          'icon': Icons.more_horiz,
          'label': 'Other',
          'value': 'Other',
          'color': Colors.purple,
        },
      ];
    }

    // deaf
    return [
      {
        'icon': Icons.sign_language,
        'label': 'Sign Language',
        'value': 'Sign Language',
        'color': Colors.blue,
      },
      {
        'icon': Icons.chat,
        'label': 'Communication',
        'value': 'Communication',
        'color': Colors.green,
      },
      {
        'icon': Icons.people,
        'label': 'Companion',
        'value': 'Companion',
        'color': Colors.orange,
      },
      {
        'icon': Icons.more_horiz,
        'label': 'Other',
        'value': 'Other',
        'color': Colors.purple,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadPatientType();
    if (widget.isEdit && widget.initialContent != null) {
      notesController.text = widget.initialContent!;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    otherTypeController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientType() async {
    final user = await TokenService.getUser();

    if (!mounted) return;

    setState(() {
      patientType = user?['patient']?['user_type'];
    });
  }

  ///  DATE & TIME
  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.n1,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: AppColors.dialogcolor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.n1,
              onPrimary: Colors.white,
              onSurface: AppColors.n1,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.inputField,
              dialHandColor: AppColors.n1,
              entryModeIconColor: AppColors.n1,
              dayPeriodColor: AppColors.n1,
              dayPeriodTextColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDate = pickedDate;
      selectedTime = pickedTime;
      selectedDateTimeLabel =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} - ${pickedTime.format(context)}';
    });
  }

  /// SUBMIT
  Future<void> _submitRequest() async {
    setState(() => isSubmitting = true);
    final token = await TokenService.getToken();

    if (selectedType == null) {
      _showSnack('Please select assistance type');
      return;
    }

    /*if (selectedLat == null || selectedLng == null) {
      _showSnack('Please select location');
      return;
    }*/

    if (selectedDate == null || selectedTime == null) {
      _showSnack('Please select date & time');
      return;
    }

    if (selectedType == 'Other' && otherTypeController.text.trim().isEmpty) {
      _showSnack('Please specify the assistance type');
      return;
    }

    final DateTime scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final String assistanceType = selectedType == 'Other'
        ? otherTypeController.text.trim()
        : selectedType!;

    final Map<String, dynamic> body = {
      "title": assistanceType,
      "content": notesController.text.trim(),
      //"scheduled_at": scheduledDateTime.toIso8601String(),
      "current_location": selectedLocationLabel, //رح يتعدللللل بالباك
      "created_at": DateTime.now().toIso8601String(),
      "city": 2, //رح تتعدل بالباك
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
              Uri.parse('$baseUrl/api/account/posts/'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(
                body,
              ),
            );
      print('Submit Response: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigationPage(role: UserRole.assistant),
          ),
        );
      } else {
        _showSnack('Failed to submit request. Please try again.');
      }
    } catch (e) {
      debugPrint('Submit error: $e');
    }

    setState(() => isSubmitting = false);
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.n1),
        actions: [
          IconButton(
            icon: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check, size: 28),
            onPressed: isSubmitting ? null : _submitRequest,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Type of Assistance'),
              if (patientType == null)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: assistanceTypes.map((type) {
                    return _typeIcon(
                      icon: type['icon'],
                      label: type['label'],
                      value: type['value'],
                      color: type['color'],
                    );
                  }).toList(),
                ),
              if (selectedType == 'Other')
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: otherTypeController,
                    decoration: InputDecoration(
                      hintText: 'Specify assistance type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Location'),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.n1),
                  //padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                },
                icon: const Icon(Icons.map, color: AppColors.n1),
                label: Text(
                  selectedLocationLabel ?? 'Select Location',
                  style:
                      TextStyle(color: const Color.fromARGB(221, 28, 27, 27)),
                ),
              ),
              const SizedBox(height: 24),
              //////teessttt
              IconButton(onPressed: (){
                Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const Incomming()),
);

              }, icon: Icon(Icons.call)),
              const _SectionTitle(title: 'Date & Time of Assistance'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: Text(selectedDateTimeLabel),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Additional Notes'),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: 'Enter any important details...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// COMPONENTS
  Widget _card({required Widget child}) {
    return Card(
      color: AppColors.dialogcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _typeIcon({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final bool isSelected = selectedType == value;

    return GestureDetector(
      onTap: () => setState(() => selectedType = value),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : color.withOpacity(0.15),
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.4),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.black87,
            ),
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
