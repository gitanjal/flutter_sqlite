import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

class AddItemForm extends StatefulWidget {
  AddItemForm({
    Key? key,
    required this.onChange
  }) : super(key: key);
  final Function onChange;

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  bool showLoader = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return showLoader
        ? Center(child: CircularProgressIndicator())
        : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Add to local DB'),
        TextFormField(
          controller: controller,
        ),
        ElevatedButton(
            onPressed: () async {
              setState(() {
                showLoader = true;
              });
              String text = controller.text;
              Map<String, dynamic> dataToAdd = {
                'title': text,
                'status': 0
              };
              bool added = await SqliteHelper().insert(dataToAdd);
              setState(() {
                showLoader = false;
              });

              if (added) {
                widget.onChange();
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'))
      ],
    );
  }
}
