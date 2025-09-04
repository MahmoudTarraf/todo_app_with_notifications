import 'package:intl/intl.dart';

String formatDeadline(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return 'N/A';
  try {
    final date = DateTime.parse(isoDate);
    return DateFormat('MMM d, yyyy – hh:mm a').format(date);
  } catch (e) {
    return isoDate;
  }
}
