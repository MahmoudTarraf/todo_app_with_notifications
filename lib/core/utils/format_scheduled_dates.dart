import 'package:get/get.dart';
import 'package:intl/intl.dart';

String formatScheduledDates(List<String> dates) {
  if (dates.isEmpty) return 'No dates selected'.tr;
  return dates.map((d) {
    try {
      final date = DateTime.parse(d);
      final dayName = DateFormat('EEEE').format(date); // e.g. Wednesday
      final formattedDate = DateFormat('MMM d, yyyy – hh:mm a').format(date);
      return '$dayName: $formattedDate';
    } catch (e) {
      return d;
    }
  }).join('\n');
}
