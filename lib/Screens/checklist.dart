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
                                labelText: 'Enter Task Name'),
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
                                labelText: 'Enter Task Desc'),
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
                          if (_formKey.currentState!.validate()) {
                            //If no validators triggered (isNotEmpty)
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ));
          dialogResult.then((bool? result) {
            if (result == true) {
              //If user clicked on "OK"

              //Extract data from respective controllers
              String name = checkListNameController.text;
              String desc = checkListDescController.text;
              appState.addNewCheckList(name, desc);
            }
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

class CheckListPage extends StatefulWidget {
  @override
  State<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
                'You have a total of ${appState.checkListArr.length} task${appState.checkListArr.length > 1 ? 's' : ''}.'),
          ),
          for (var checklist in appState.checkListArr)
            Container(
              color: theme.colorScheme.primaryContainer,
              child: SizedBox(
                width: 450,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                        value: checklist.checked,
                        checkColor: Colors.white,
                        title: Text(
                          checklist.name,
                          style: TextStyle(decoration: checklist.checked?TextDecoration.lineThrough:TextDecoration.none)
                        ),
                        subtitle: Text(
                            checklist.desc,
                            style: TextStyle(decoration: checklist.checked?TextDecoration.lineThrough:TextDecoration.none)
                        ),
                        secondary: Icon(
                          Icons.task_alt_outlined,
                          color: Colors.black,
                        ),
                        tileColor: theme.focusColor,
                        onChanged: (bool? value) {
                          setState(() {
                            checklist.checked = value!;
                          });
                        }),
                  ),
                ),
              ),
            )
        ],
      );
    }
  }
}
