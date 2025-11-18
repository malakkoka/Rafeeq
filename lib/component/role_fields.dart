import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:front/component/textform.dart';

class RoleFields extends StatefulWidget {
  final String? selectedRole;
  final TextEditingController patientAge;
  final TextEditingController assistantnumber;
  final TextEditingController assistage;
  final TextEditingController assistantDept;
  final TextEditingController volunteerage;
  final TextEditingController volunteerHours;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const RoleFields({
    super.key,
    required this.selectedRole,
    required this.assistantnumber,
    required this.patientAge,
    required this.assistage,
    required this.assistantDept,
    required this.volunteerage,
    required this.volunteerHours,
    this.validator,
    this.autovalidateMode, 
  });

  @override
  State<RoleFields> createState() => _RoleFieldsState();
}

class _RoleFieldsState extends State<RoleFields> {
  
  String? disability; 
  String? driverslicense;
  bool canLipRead = false;
  bool usesSignLang = false;


String? _validateAdult(String? v) {
    if (v == null || v.trim().isEmpty) return "Please enter your age";
    final age = int.tryParse(v);
    if (age == null) return "Please enter a valid number";
    if (age < 18) return "Age must be at least 18";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectedRole) {
      case 'Patient':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Disability type",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            Container(
              decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: 
                    RadioListTile<String>(
                    title: const Text("Blind"),
                    value: "blind",
                    groupValue: disability,
                    onChanged: (val) {
                    setState(() => disability = val);
                    },
                  ),
                ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Deaf"),
                      value: "deaf",
                      groupValue: disability,
                      onChanged: (val) {
                        setState(() => disability = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (disability == "deaf") ...[
        const Gap(8),
        const Text(
          "Communication abilities",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text("Can write & read"),
          value: canLipRead,
          onChanged: (val) {
            setState(() => canLipRead = val ?? false);
          },
        ),
        CheckboxListTile(
          title: const Text("Uses sign language"),
          value: usesSignLang,
          onChanged: (val) {
            setState(() => usesSignLang = val ?? false);
          },
        ),
      ],
            const Gap(12),
            const Text(
              "Assistant number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            CustomText(
              hinttext: "enter Assistant number",
              mycontroller: widget.assistantnumber, // ✅ استخدمي widget.<controller>
            ),
            const Gap(12),
            const Text(
              "Age",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            CustomText(
              hinttext: "enter your age",
              mycontroller: widget.patientAge,
              validator: _validateAdult, 
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            
          ],
        );

      case 'First Assistant':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "age",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            CustomText(
              hinttext: "enter your age",
              mycontroller: widget.assistage,
              validator: _validateAdult,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            
          ],
        );

      case 'Volunteer':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "age",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            CustomText(
              hinttext: "enter age",
              mycontroller: widget.volunteerage,

            ),
            const Gap(12),
            const Text(
              "Driver's license",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              ),
              
              child: Row(
                children: [
                  Expanded(
                    child: 
                    RadioListTile<String>(
                    title: const Text("yes"),
                    value: "yes",
                    groupValue: driverslicense,
                    onChanged: (val) {
                    setState(() => driverslicense = val);
                    },
                  ),
                ),

                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("no"),
                      value: "no",
                      groupValue: driverslicense,
                      onChanged: (val) {
                        setState(() => driverslicense = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
