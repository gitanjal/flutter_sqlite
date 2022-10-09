import 'package:sqflite/sqflite.dart';

final String tableName='items';
final String colId='id';
final String colTitle='title';
final String colStatus='status';

class SqliteHelper {
  late Database _database;

  open() async {
    _database = await openDatabase(
      'local_db.db',
      version: 1,
      onCreate: (Database db,int version) async{
        await db.execute('Create table $tableName ('
            '$colId integer primary key autoincrement,'
            '$colTitle text not null,'
            '$colStatus integer not null'
            ')');
      }
    );
  }

  Future<bool> insert(Map<String,dynamic> dataToInsert) async{
    await open();
    int rowId=await _database.insert(tableName, dataToInsert);
    return rowId>0;
  }

  Future<List<Map>> fetchAll() async {
    await open();
    List<Map> items=await _database.query(tableName);
    return items;
  }

  Future<List<Map>> fetchAllOrderedByID() async {
    await open();
    List<Map> items=await _database.query(tableName,orderBy: 'id desc');
    return items;
  }

  Future<Map> fetchOne(int id) async {
    await open();
    List<Map> items=await _database.query(tableName,where: '$colId=?',whereArgs: [id]);
    return items.first;
  }

  Future<bool> update(int id,Map<String,dynamic> dataToUpdate) async {
    await open();
    int rowsUpdated=await _database.update(tableName, dataToUpdate,where: '$colId=?',whereArgs: [id]);
    return rowsUpdated>0;
  }

  Future<bool> delete(int id) async {
    await open();
    int rowsDeleted=await _database.delete(tableName,where: '$colId=?',whereArgs: [id]);
    return rowsDeleted==1;
  }

  Future<bool> deleteAll()async{
    await open();
    int rowsDeleted=await _database.delete(tableName);
    return rowsDeleted>0;
  }
}
