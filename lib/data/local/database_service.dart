import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/core/const_data/app_strings.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "tasks.db");
    final database = await openDatabase(
      databasePath,
      version: 1, // added users table for offline content
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

// on upgrade function
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  //
  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE ${AppStrings.tasksTableName} (
    ${AppStrings.tasksIdColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${AppStrings.tasksTitleColumnName} TEXT NOT NULL,
    ${AppStrings.tasksContentColumnName} TEXT NOT NULL,
    ${AppStrings.tasksFrequencyColumnName} TEXT NOT NULL,
    ${AppStrings.tasksDatesColumnName} TEXT NOT NULL,
    ${AppStrings.tasksDeadlineColumnName} TEXT,
    ${AppStrings.tasksPriorityColumnName} TEXT NOT NULL,
    ${AppStrings.tasksTypeColumnName} TEXT NOT NULL,
    ${AppStrings.tasksIsCompletedColumnName} INTEGER NOT NULL
  )
''');

    await db.execute('''
    CREATE TABLE ${AppStrings.notesTableName} (
      ${AppStrings.notesIdColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${AppStrings.notesTitleColumnName} TEXT NOT NULL,
      ${AppStrings.notesContentColumnName} TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE ${AppStrings.usersTableName} (
      ${AppStrings.usersIdColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${AppStrings.usersNameColumnName} TEXT NOT NULL,
      ${AppStrings.usersEmailColumnName} TEXT NOT NULL,
      ${AppStrings.usersRemainingUpdatesColumnName} INTEGER NOT NULL,
      ${AppStrings.usersRemainingDeletesColumnName} INTEGER NOT NULL,
      ${AppStrings.usersTaskStrikesColumnName} INTEGER NOT NULL
    )
  ''');

    await db.execute('''
  CREATE TABLE ${AppStrings.failedTasksTableName} (
    ${AppStrings.failedTasksIdColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${AppStrings.tasksTitleColumnName} TEXT NOT NULL,
    ${AppStrings.tasksContentColumnName} TEXT NOT NULL,
    ${AppStrings.tasksFrequencyColumnName} TEXT NOT NULL,
    ${AppStrings.tasksDatesColumnName} TEXT NOT NULL,
    ${AppStrings.tasksDeadlineColumnName} TEXT,
    ${AppStrings.tasksIsCompletedColumnName} INTEGER NOT NULL,
    ${AppStrings.tasksTypeColumnName} TEXT NOT NULL,
    ${AppStrings.tasksPriorityColumnName} TEXT NOT NULL,
    ${AppStrings.failedUserIdColumnName} INTEGER NOT NULL,
    ${AppStrings.fcmTokenColumnName} TEXT,
    ${AppStrings.taskFailedAt} TEXT NOT NULL
  )
''');
    await db.execute('''
  CREATE TABLE ${AppStrings.achievementsTableName} (
    ${AppStrings.usersIdColumnName} INTEGER PRIMARY KEY,
    ${AppStrings.achievementstitleColumnName} TEXT NOT NULL,
    ${AppStrings.achievementsSubTitleColumnName} TEXT,
    ${AppStrings.achievementsConditionColumnName} INTEGER NOT NULL,
    ${AppStrings.tasksIsCompletedColumnName} INTEGER NOT NULL DEFAULT 0,
    ${AppStrings.achievementsachievedAtColumnName} TEXT NOT NULL,
    ${AppStrings.achievementsProgressColumnName} INTEGER NOT NULL
  )
''');
  }

  Future<void> deleteDatabaseFile() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "tasks.db");

    // Close database if it's open
    if (_db != null) {
      await _db!.close();
      _db = null;
    }

    // Delete the file
    await deleteDatabase(databasePath);
  }

  Future<void> clearUserData() async {
    final db = await database;
    await db.delete(AppStrings.tasksTableName);
    await db.delete(AppStrings.usersTableName);
    await db.delete(AppStrings.failedTasksTableName);
    await db.delete(AppStrings.notesTableName);
  }
}
