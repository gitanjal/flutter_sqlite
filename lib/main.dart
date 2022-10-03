import 'package:flutter/material.dart';
import 'package:flutter_sqlite/add_item.dart';
import 'package:flutter_sqlite/each_item.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _deletingAll=false;
  bool _orderDesc=false;
  Future<List<Map>> _futureData=SqliteHelper().fetchAll();

  void _addItem() {
    /*todo 10: Add an item*/
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AddItemForm(onChange: refreshItems,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping SQLite'),
        actions: [
          IconButton(onPressed: (){
            _orderDesc=!_orderDesc;
            orderByID(_orderDesc);
          }, icon: Icon(Icons.short_text)),
          _deletingAll?CircularProgressIndicator():IconButton(onPressed: () async {
            setState((){
              _deletingAll=true;
            });
            bool deleted=await SqliteHelper().deleteAll();
            if(deleted)
              {
                refreshItems();
              }
            setState((){
              _deletingAll=false;
            });
          }, icon: Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder<List<Map>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            List<Map> items = snapshot.data!;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Map item = items[index];
                  return EachItem(item: item,onChange:refreshItems);
                });
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  refreshItems(){
    setState((){
      _futureData=SqliteHelper().fetchAll();
    });
  }

  orderByID(bool desc){
    setState((){
      _futureData=SqliteHelper().fetchAllOrderedByID(desc:desc);
    });
  }
}


