import 'package:flutter/material.dart';
import 'package:todo_app_with_notifications/core/const_data/my_size.dart';

class AppStrings {
  //users table
  static const String usersTableName = "users",
      usersIdColumnName = "id",
      usersNameColumnName = "name",
      usersEmailColumnName = "email",
      usersRemainingUpdatesColumnName = "remainingUpdates",
      usersRemainingDeletesColumnName = "remainingDeletes",
      usersTaskStrikesColumnName = "taskStrikes";
  //tasks table
  static const String tasksTableName = "tasks",
      tasksIdColumnName = "id",
      tasksContentColumnName = "content",
      tasksFrequencyColumnName = "frequency",
      tasksTitleColumnName = "title",
      tasksIsCompletedColumnName = "isCompleted",
      tasksDatesColumnName = "dates", // Will now store JSON list
      tasksPriorityColumnName = "taskPriority",
      // tasksIsSyncedColumnName = "isSynced",
      // tasksSyncActionColumnName = "syncAction",
      tasksTypeColumnName = "taskType";
  static const String tasksDeadlineColumnName = "deadline",
      failedTasksTableName = 'failedTasks',
      taskFailedAt = 'failedAt',
      fcmTokenColumnName = 'fcmToken',
      failedUserIdColumnName = 'userId',
      failedTasksIdColumnName = 'taskId';
  //notes table

  static const String notesTableName = "notes",
      notesIdColumnName = "id",
      notesTitleColumnName = "title",
      notesContentColumnName = "content";
  //achievments table
  static const String achievementsTableName = "achievements",
      achievementstitleColumnName = 'title',
      achievementsSubTitleColumnName = 'subTitle',
      achievementsConditionColumnName = 'condition',
      achievementsachievedAtColumnName = 'achievedAt',
      achievementsProgressColumnName = 'progress';

  static const darkModeString = Text(
    "Dark Mode",
    style: TextStyle(
      fontSize: MySize.fontSizeLg,
    ),
  );
  static const lightModeString = Text(
    "Light Mode",
    style: TextStyle(
      fontSize: MySize.fontSizeLg,
    ),
  );
}
