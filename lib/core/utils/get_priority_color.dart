import 'package:flutter/material.dart';

Color getPriorityColor(BuildContext context, String priority) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  switch (priority.toLowerCase()) {
    case 'high':
      return isDark ? Colors.red[300]! : Colors.red[700]!;
    case 'medium':
      return isDark ? Colors.orange[300]! : Colors.orange[700]!;
    case 'low':
      return isDark ? Colors.green[300]! : Colors.green[700]!;
    default:
      return isDark ? Colors.grey[400]! : Colors.grey[700]!;
  }
}
