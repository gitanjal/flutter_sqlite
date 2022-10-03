import 'package:flutter/material.dart';
import 'package:flutter_sqlite/item_details.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

class EachItem extends StatefulWidget {
  const EachItem({Key? key, required this.item, required this.onChange})
      : super(key: key);

  final Map item;
  final Function onChange;

  @override
  State<EachItem> createState() => _EachItemState();
}

class _EachItemState extends State<EachItem> {
  late bool status;
  bool deleting = false;
  SqliteHelper sqliteHelper = SqliteHelper();

  initState() {
    super.initState();
    status = widget.item['status'] == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetails(widget.item['id'])));
      },
      title: Text(widget.item['title']),
      leading: Checkbox(
        value: status,
        onChanged: (bool? value) {
          Map<String, dynamic> dataToUpdate = {'status': value! ? 1 : 0};
          sqliteHelper.update(widget.item['id'], dataToUpdate);

          setState(() {
            status = value;
          });
        },
      ),
      trailing: deleting
          ? Container(height: 40, width: 40, child: CircularProgressIndicator())
          : IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                setState(() {
                  deleting = true;
                });
                bool deleted = await sqliteHelper.delete(widget.item['id']);
                if (deleted) {
                  widget.onChange();
                }
                setState(() {
                  deleting = false;
                });
              },
            ),
    );
  }
}
