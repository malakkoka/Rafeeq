import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:front/color.dart';

/// Reusable dropdown for selecting a role.
/// Values: Patient, First Assistant, Volunteer
class RoleDropdown extends StatelessWidget {
  final String? value; // القيمة المختارة حالياً
  final ValueChanged<String?> onChanged; // ماذا يحدث عند تغيير الاختيار
  final String hintText; // نص تلميح عند عدم وجود قيمة
  final EdgeInsetsGeometry? margin; // (اختياري) هامش خارجي

  const RoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText = 'Choose your role',
    this.margin,
  });

  static const List<String> roles = [
    'Patient',
    'First Assistant',
    'Volunteer',
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color.fromARGB(255, 199, 197, 197);

    return Container(
      margin: margin,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: value,
          hint: Text(hintText,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primary,
              )),
          items: roles
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,

          buttonStyleData: ButtonStyleData(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.background),
            ),
          ),

          // قائمة الخيارات
          dropdownStyleData: DropdownStyleData(
            maxHeight: 220,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // عنصر داخل القائمة
          menuItemStyleData: const MenuItemStyleData(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),

          // الأيقونة
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.accent,
            ),
            openMenuIcon: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}
