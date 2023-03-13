import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/Logic/logic.dart';
import 'package:namer_app/Objects/objects.dart';

class CheckListHome extends StatefulWidget {
  @override
  State<CheckListHome> createState() => _CheckListHomeState();
}

class _CheckListHomeState extends State<CheckListHome> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    final TextEditingController checkListNameController =
    TextEditingController();
    final TextEditingController checkListDescController =
    TextEditingController();

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<bool?> dialogResult = showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Add New CheckList'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: checkListNameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter Checklist Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: checkListDescController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter Checklist Desc'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      //Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      //Validate if TextControllers are empty?
                      if (_formKey.currentState!.validate()) { //If no validators triggered (isNotEmpty)
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: const Text('OK'),
                  )
                ],
              ));
          dialogResult.then((bool? result) {
            //If user clicked on "OK"
            String name = checkListNameController.text;
            String desc = checkListDescController.text;
          });
        },
        backgroundColor: theme.colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: CheckListPage(),
      ),
    );
  }
}

class CheckListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.checkListArr.isEmpty) {
      return Center(
        child: Text('No checklists yet.'),
      );
    } else {
      return ListView(
        children: [
          for (var checklist in appState.checkListArr)
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.check_box_outlined,
                  semanticLabel: 'CheckBox',
                ),
                color: theme.colorScheme.primary,
                onPressed: () {
                  appState.tickCheckList(checklist);
                },
              ),
              title: Text(checklist.name.toString()),
            ),
        ],
      );
    }
  }
}