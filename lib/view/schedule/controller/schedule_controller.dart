import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/core/const_data/app_strings.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import '../../../core/class/crud.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/service/app_link.dart';
import '../../../core/service/messages.dart';
import '../../../core/service/network_manager.dart';
import '../../../data/local/database_service.dart';

class ScheduleController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<TaskModel> allTasks = <TaskModel>[].obs;
  RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Whenever selectedDate changes, filter tasks
    ever(selectedDate, (_) => _filterTasks());
    loadTasks();
  }

  // Load tasks from API, fallback to local DB
  Future<void> loadTasks() async {
    isLoading.value = true;

    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(AppLink.getTasks);

        result.fold(
          (error) async {
            Messages.getSnackMessage(
              'Something went wrong'.tr,
              'Loading Tasks from local Database.'.tr,
              ColorsManager.grey,
            );
            await loadTasksFromLocalDB();
          },
          (responseBody) async {
            if (responseBody is List) {
              final db = await _databaseService.database;
              await db.delete(AppStrings.tasksTableName);

              allTasks.clear();
              for (var taskMap in responseBody) {
                try {
                  final task = TaskModel.fromMap(taskMap);
                  allTasks.add(task);
                  await db.insert(
                    AppStrings.tasksTableName,
                    task.toMap(),
                    conflictAlgorithm: ConflictAlgorithm.replace,
                  );
                } catch (e) {
                  Messages.getSnackMessage(
                    'Something went wrong'.tr,
                    'Loading Tasks from local Database.'.tr,
                    ColorsManager.grey,
                  );
                  await loadTasksFromLocalDB();
                }
              }
              _filterTasks();
            } else {
              await loadTasksFromLocalDB();
            }
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loading Tasks from local Database.'.tr,
          ColorsManager.grey,
        );
        await loadTasksFromLocalDB();
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
      await loadTasksFromLocalDB();
    } finally {
      isLoading.value = false;
    }
  }

  // Load tasks from local DB
  Future<void> loadTasksFromLocalDB() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.tasksTableName);

    allTasks.clear();
    for (var value in data) {
      allTasks.add(TaskModel.fromMap(value));
    }

    _filterTasks();
  }

  // Filter tasks by selectedDate
  void _filterTasks() {
    final formattedSelected =
        DateFormat('yyyy-MM-dd').format(selectedDate.value);

    filteredTasks.value = allTasks.where((task) {
      if (task.deadline != null) {
        final taskDate = DateFormat('yyyy-MM-dd').format(task.deadline!);
        return taskDate == formattedSelected;
      }
      return false;
    }).toList();
  }

  // Select a new date
  void selectDate(DateTime date) {
    selectedDate.value = date;
  }
}
