// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/notification_model.dart';
import '../variables.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();

  static Database? _database;

  NotificationDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('${Variable.notificationTable}.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NULL';
    const integerType = 'INTEGER NULL';

    await db.execute('''
CREATE TABLE ${Variable.notificationTable} ( 

  ${NotificationDataFields.id} $integerType,
  ${NotificationDataFields.patientId} $integerType,
  ${NotificationDataFields.patientName} $textType,
  ${NotificationDataFields.nurseId} $integerType,
  ${NotificationDataFields.roomNo} $integerType,
  ${NotificationDataFields.wardNo} $integerType,
  ${NotificationDataFields.medicName} $textType,
  ${NotificationDataFields.medicDate} $textType,
  ${NotificationDataFields.nurseName} $textType
  
  )
''');
  }

  Future<void> insertUpdate(dynamic json) async {
    final db = await instance.database;

    const columns = '${NotificationDataFields.id},'
        '${NotificationDataFields.patientId},'
        '${NotificationDataFields.patientName},'
        '${NotificationDataFields.nurseId},'
        '${NotificationDataFields.roomNo},'
        '${NotificationDataFields.wardNo},'
        '${NotificationDataFields.medicName},'
        '${NotificationDataFields.medicDate},'
        '${NotificationDataFields.nurseName}';
    final insertValues = "${json[NotificationDataFields.id]},"
        "${json[NotificationDataFields.patientId]},"
        "'${json[NotificationDataFields.patientName]}',"
        "${json[NotificationDataFields.nurseId]},"
        "${json[NotificationDataFields.roomNo]},"
        "${json[NotificationDataFields.wardNo]},"
        "'${json[NotificationDataFields.medicName]}',"
        "'${json[NotificationDataFields.medicDate]}',"
        "'${json[NotificationDataFields.nurseName]}'";

    await NotificationDatabase.instance
        .readNotificationById(json[NotificationDataFields.id])
        .then((data) async {
      if (data != null) {
        await db!.transaction((txn) async {
          var batch = txn.batch();

          batch.rawUpdate('''
                UPDATE ${Variable.notificationTable}
                SET ${NotificationDataFields.patientId} = ?, 
                ${NotificationDataFields.patientName} = ?, 
                ${NotificationDataFields.nurseId} = ?, 
                 ${NotificationDataFields.roomNo} = ?, 
                ${NotificationDataFields.wardNo} = ?, 
                ${NotificationDataFields.medicName} = ?, 
                ${NotificationDataFields.medicDate} = ?, 
                ${NotificationDataFields.nurseName} = ?    
                
                WHERE ${NotificationDataFields.id} = ?
                ''', [
            json[NotificationDataFields.patientId],
            json[NotificationDataFields.patientName],
            json[NotificationDataFields.nurseId],
            json[NotificationDataFields.roomNo],
            json[NotificationDataFields.wardNo],
            '${json[NotificationDataFields.medicName]}',
            '${json[NotificationDataFields.medicDate]}',
            '${json[NotificationDataFields.nurseName]}',
            json[NotificationDataFields.id]
          ]);

          await batch.commit(noResult: true);
        });
      } else {
        await db!.transaction((txn) async {
          var batch = txn.batch();
          batch.rawInsert(
              'INSERT INTO ${Variable.notificationTable} ($columns) VALUES ($insertValues)');

          await batch.commit(noResult: true);
        });
      }
    });
  }

  Future<dynamic> readNotificationById(int id) async {
    final db = await instance.database;

    final maps = await db!.query(
      Variable.notificationTable,
      columns: NotificationDataFields.values,
      where: '${NotificationDataFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> readAllNotifications() async {
    final db = await instance.database;

    final result = await db!.query(
      Variable.notificationTable,
      orderBy: "${NotificationDataFields.id} ASC",
    );

    return result;
  }

  Future deleteAll() async {
    final db = await instance.database;

    db!.delete(Variable.notificationTable);
  }

  Future deleteAllById(int id) async {
    final db = await instance.database;

    db!.delete(Variable.notificationTable, where: 'chart_id = $id');
  }

  Future deleteAllByNurseId(int id) async {
    final db = await instance.database;

    db!.delete(Variable.notificationTable, where: 'nurse_id = $id');
  }

  Future close() async {
    final db = await instance.database;

    db!.close();
  }
}
