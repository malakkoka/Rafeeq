import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:front/component/textform.dart';

class RoleFields extends StatefulWidget {
  final String? selectedRole;
  final TextEditingController patientAge;
  final TextEditingController assistantnumber;
  final TextEditingController assistage;
  final TextEditingController volunteerage;
  final String? Function(String?)? validator;
    final String? Function(String?)? disability;

  final AutovalidateMode? autovalidateMode;

  const RoleFields({
    super.key,
    required this.selectedRole,
    required this.assistantnumber,
    required this.patientAge,
    required this.assistage,
    required this.volunteerage,
    this.disability,
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
      
      case 'Assistant':
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
              hinttext: "enter your age",
              mycontroller: widget.assistage,
              validator: _validateAdult,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
