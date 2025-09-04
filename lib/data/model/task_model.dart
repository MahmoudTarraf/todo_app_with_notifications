// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../core/const_data/app_strings.dart';
import 'task_settings.dart';

class TaskModel {
  int? id;
  String title;
  String content;
  String frequency; // 'everyday', 'everyweek', or 'custom'
  List<String> dates; // for scheduled
  DateTime? deadline; // ✅ store it as DateTime

  bool isCompleted;
  TaskType taskType;
  TaskPriority taskPriority;
  // bool isSynced; // NEW
  // SyncAction syncAction; // NEW: 'create', 'update', 'delete'

  TaskModel({
    this.id,
    required this.title,
    required this.frequency,
    required this.dates,
    required this.isCompleted,
    required this.content,
    required this.taskPriority,
    required this.taskType,
    // this.isSynced = true,
    // required this.syncAction,
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      AppStrings.tasksIdColumnName: id,
      AppStrings.tasksTitleColumnName: title,
      AppStrings.tasksContentColumnName: content,
      AppStrings.tasksFrequencyColumnName: frequency,
      AppStrings.tasksDatesColumnName: jsonEncode(dates),
      AppStrings.tasksDeadlineColumnName:
          deadline?.toIso8601String(), // ✅ ISO string
      AppStrings.tasksIsCompletedColumnName: isCompleted ? 1 : 0,
      AppStrings.tasksPriorityColumnName: taskPriority.name,
      AppStrings.tasksTypeColumnName: taskType.name,
      // AppStrings.tasksIsSyncedColumnName: isSynced ? 1 : 0,
      // AppStrings.tasksSyncActionColumnName: syncAction.name,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    DateTime? deadlineUtc;
    if (map[AppStrings.tasksDeadlineColumnName] != null) {
      try {
        deadlineUtc =
            DateTime.parse(map[AppStrings.tasksDeadlineColumnName].toString());
      } catch (_) {
        deadlineUtc = null;
      }
    }

    return TaskModel(
      id: map[AppStrings.tasksIdColumnName],
      title: map[AppStrings.tasksTitleColumnName] ?? '',
      content: map[AppStrings.tasksContentColumnName] ?? '',
      frequency: map[AppStrings.tasksFrequencyColumnName] ?? '',
      dates: _parseDates(map['dates']),
      // ✅ Convert UTC → Local here
      deadline: deadlineUtc?.toLocal(),
      isCompleted: map[AppStrings.tasksIsCompletedColumnName] == 1,
      taskPriority: TaskPriority.values.firstWhere(
        (e) => e.name == map[AppStrings.tasksPriorityColumnName],
        orElse: () => TaskPriority.medium,
      ),
      taskType: TaskType.values.firstWhere(
        (e) => e.name == map[AppStrings.tasksTypeColumnName],
        orElse: () => TaskType.oneTime,
      ),
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, content: $content, frequency: $frequency, dates: $dates, deadline: $deadline, isCompleted: $isCompleted, taskType: $taskType, taskPriority: $taskPriority)';
  }

  static List<String> _parseDates(dynamic rawDates) {
    try {
      if (rawDates is String) {
        if (rawDates == 'N/A' || rawDates.trim().isEmpty) {
          return [];
        }
        final decoded = jsonDecode(rawDates);
        if (decoded is List) {
          return List<String>.from(decoded.map((e) => e.toString()));
        }
      } else if (rawDates is List) {
        return List<String>.from(rawDates.map((e) => e.toString()));
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
