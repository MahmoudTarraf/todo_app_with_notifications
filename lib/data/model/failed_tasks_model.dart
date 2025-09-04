import 'dart:convert';
import 'package:todo_app_with_notifications/data/model/task_settings.dart';

class FailedTaskModel {
  final int taskId;
  final String title;
  final String content;
  final String frequency;
  final List<String> dates;
  final DateTime? deadline;
  final bool isCompleted;
  final TaskType taskType;
  final TaskPriority taskPriority;
  final int userId;
  final String? fcmToken;
  final DateTime? failedAt;

  FailedTaskModel({
    required this.taskId,
    required this.title,
    required this.content,
    required this.frequency,
    required this.dates,
    this.deadline,
    required this.isCompleted,
    required this.taskType,
    required this.taskPriority,
    required this.userId,
    this.fcmToken,
    required this.failedAt,
  });

  /// ✅ fromMap (for database/SQLite or backend responses)
  factory FailedTaskModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString()).toLocal();
      } catch (_) {
        return null;
      }
    }

    return FailedTaskModel(
      taskId: map['taskId'] is int
          ? map['taskId']
          : int.tryParse(map['taskId'].toString()) ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      frequency: map['frequency'] ?? '',
      dates: _parseDates(map['dates']),
      deadline: parseDate(map['deadline']),
      isCompleted: map['isCompleted'] == 1,
      taskType: TaskType.values.firstWhere(
        (e) => e.name == map['taskType'],
        orElse: () => TaskType.oneTime,
      ),
      taskPriority: TaskPriority.values.firstWhere(
        (e) => e.name == map['taskPriority'],
        orElse: () => TaskPriority.medium,
      ),
      userId: map['userId'] is int
          ? map['userId']
          : int.tryParse(map['userId'].toString()) ?? 0,
      fcmToken: map['fcmToken'],
      failedAt: parseDate(map['failedAt']),
    );
  }

  /// ✅ toMap (for inserting/updating in database)
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'content': content,
      'frequency': frequency,
      'dates': jsonEncode(dates),
      'deadline': deadline?.toUtc().toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'taskType': taskType.name,
      'taskPriority': taskPriority.name,
      'userId': userId,
      'fcmToken': fcmToken,
      'failedAt': failedAt?.toUtc().toIso8601String(),
    };
  }

  /// ✅ helper to parse dates flexibly
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

  @override
  String toString() {
    return 'FailedTaskModel(taskId: $taskId, title: $title, content: $content, frequency: $frequency, dates: $dates, deadline: $deadline, isCompleted: $isCompleted, taskType: $taskType, taskPriority: $taskPriority, userId: $userId, fcmToken: $fcmToken, failedAt: $failedAt)';
  }
}
