/*todo 2: Create a helper class to perform all operations related to local DB*/
import 'package:sqflite/sqflite.dart';

final String tableName='items';
final String colId='id';
final String colTitle='title';
final String colStatus='status';

class SqliteHelper{
  late Database _database;

  open() async {
    /*todo 3: Open database connection*/
    _database=await openDatabase(
      'local_db.db',
      version: 1,
      onCreate: (Database db,int version) async {
        await db.execute('Create table $tableName ('
            '$colId integer primary key autoincrement,'
            '$colTitle text not null,'
            '$colStatus integer not null'
            ')');
      }
    );
  }
  Future<bool> insert(Map<String,dynamic> dataToInsert) async {
    /*todo 4: Insert data
    * -4.1: Call open() to open a database connection,
    * -4.2: Call the function insert() on the instance of the database,
    *       pass the name of the table, and a Map containing the data to insert
    *
    * */
    await open();
    int rowId=await _database.insert(tableName, dataToInsert);
    return rowId>0;
  }
  Future<List<Map>> fetchAll() async {
    /*todo 5: Fetch all items from the db*/
    await open();
    List<Map> items=await _database.query(tableName);
    // List<Map> items=await _database.query('tasks',orderBy: 'id desc');
    return items;
  }
  Future<Map> fetchOne(int id) async {
    /*todo 6: Fetch one item from the db*/
    await open();
    List<Map> items=await _database.query(tableName,where: '$colId=?',whereArgs: [id]);
    return items.first;
  }
  Future<bool> update(int id,Map<String,dynamic> dataToUpdate) async {
    /*todo 7: Update one item by the id*/
    await open();
    int numOfChanges=await _database.update(tableName, dataToUpdate,where: 'id=?',whereArgs: [id]);
    return numOfChanges>0;
  }
  delete(int id) async {
    /*todo 8: Delete one item by the id*/
    await open();
    int numOfRows=await _database.delete(tableName,where: 'id=?',whereArgs: [id]);
    return numOfRows==1;
  }

  deleteAll() async {
    /*todo 9: Delete all items*/
    await open();
    int numOfRows=await _database.delete(tableName);
    return numOfRows>0;
  }

  Future<List<Map>> fetchAllOrderedByID({bool desc=false}) async {
    /*todo 5: Fetch all items from the db*/
    await open();
    // List<Map> items=await _database.query(tableName);
    List<Map> items=await _database.query(tableName,orderBy: 'id ${desc?'desc':'asc'}');
    return items;
  }
}