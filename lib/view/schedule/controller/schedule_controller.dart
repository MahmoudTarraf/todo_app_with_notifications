import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_with_notifications/core/const_data/app_strings.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import '../../../data/local/database_service.dart';

class ScheduleController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  final allTasks = <TaskModel>[].obs;
  final filteredTasks = <TaskModel>[].obs;
  final visibleDays = <DateTime>[].obs;

  final _databaseService = DatabaseService.instance;

  final int daysBefore = 365; // go 1 year back
  final int daysAfter = 730; // go 2 years forward

  @override
  void onInit() {
    super.onInit();
    generateVisibleDays();
    loadTasks();
  }

  void generateVisibleDays() {
    final today = DateTime.now();
    visibleDays.clear();
    for (int i = -daysBefore; i <= daysAfter; i++) {
      final date = today.add(Duration(days: i));
      visibleDays.add(DateTime(date.year, date.month, date.day));
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    _filterTasks();
  }

  Future<void> loadTasks() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.tasksTableName);
    final taskModels = data.map((e) => TaskModel.fromMap(e)).toList();
    allTasks.assignAll(taskModels);
    _filterTasks();
  }

  void _filterTasks() {
    final formattedSelected =
        DateFormat('yyyy-MM-dd').format(selectedDate.value);
    filteredTasks.value = allTasks.where((task) {
      try {
        if (task.deadline != null) {
          final taskDate = DateFormat('yyyy-MM-dd').format(task.deadline!);
          return taskDate == formattedSelected;
        }
      } catch (e) {
        rethrow;
      }
      return false;
    }).toList();
  }
}
