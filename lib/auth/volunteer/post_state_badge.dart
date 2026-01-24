import 'package:flutter/material.dart';

Widget buildStateBadge(
  int state,
) {
  final label = postStateLabels[state] ?? "Unknown";

  Color bgColor;
  Color textColor;
  IconData icon = Icons.help_outline;

  switch (state) {
    case 0:
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      icon = Icons.priority_high;
      break;
    case 1:
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      icon = Icons.volunteer_activism;
      break;
    case 2:
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      icon = Icons.check_circle;
      break;
    default:
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade700;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: textColor,
        ),
        const SizedBox(width: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

const Map<int, String> postStateLabels = {
  0: "Pending",
  1: "Accepted",
  2: "Completed",
};
