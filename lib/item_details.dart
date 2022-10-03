import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

class ItemDetails extends StatelessWidget {
  ItemDetails(this.id,{Key? key}) : super(key: key){
    _futureData=SqliteHelper().fetchOne(id);
  }
  late Future<Map> _futureData;
  int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Map>(
            future: _futureData,
            builder: (context,snapshot){
              if(snapshot.hasError)
                {
                  return Center(child: Text(snapshot.error.toString()));
                }

              if(snapshot.hasData)
                {
                  Map item=snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(item['title']),
                      Text(item['status']==1?'Purchased':'To purchase'),
                    ],
                  );
                }

              return Center(child: CircularProgressIndicator());

            }),
      ),
    );
  }
}
