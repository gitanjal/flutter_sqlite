import 'package:flutter/material.dart';
import 'package:flutter_sqlite/add_item.dart';
import 'package:flutter_sqlite/each_item.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  int _counter = 0;
  bool _deletingAll=false;
  bool _orderDesc=false;
  Future<List<Map>> _futureData=SqliteHelper().fetchAll();

  void _addItem() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
    Future<List<Map>> items;
    if(desc)
      {
        items=SqliteHelper().fetchAllOrderedByID();
      }
    else
      {
        items=SqliteHelper().fetchAll();
      }
    setState((){
      _futureData=items;
    });
  }
}