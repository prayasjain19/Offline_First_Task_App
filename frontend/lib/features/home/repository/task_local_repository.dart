import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");
    return openDatabase(
      path,
      version: 4,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('ALTER TABLE $tableName ADD COLUMN color TEXT NOT NULL',);
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          uid TEXT NOT NULL,
          dueAt TEXT NOT NULL,
          color TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isSynced INTEGER NOT NULL
      )
  ''');
      },
    );
  }

  Future<void> inserTask(TaskModel task) async {
    final db = await database;
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }
      return tasks;
    }
    return [];
  }
}
