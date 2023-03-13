import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/Objects/objects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favourites = <WordPair>[];
  var checkListArr = <CheckList>[];

  void toggleFavourite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }

    notifyListeners();
  }

  void addNewCheckList(String name, String desc) {
    bool checked = false;

    if (name.isNotEmpty && desc.isNotEmpty) {
      CheckList checklist = CheckList(name, desc, checked);
      checkListArr.add(checklist);
    }

    notifyListeners();
  }

  void tickCheckList(CheckList checkList) {
    //Check if checklist is ticked
    if (checkList.checked == true) {
      checkList.checked == false;
    } else {
      checkList.checked = true;
    }
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void removeFavourite(WordPair pair) {
    favourites.remove(pair);
    notifyListeners();
  }
}

class CheckListHome extends StatelessWidget {
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: checkListNameController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter Checklist Name',
                          ),
                        ),
                        TextField(
                          controller: checkListDescController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Checklist Desc'),
                        )
                      ],
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
                          Navigator.of(context).pop(true);
                          //Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ));
          dialogResult.then((bool? result) { //If user clicked on "OK"

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

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    } else {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Text('You have liked ${appState.favourites.length} word(s).'),
          ),
          for (var pair in appState.favourites)
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                color: theme.colorScheme.primary,
                onPressed: () {
                  appState.removeFavourite(pair);
                },
              ),
              title: Text(
                pair.asLowerCase,
                semanticsLabel: pair.asPascalCase,
              ),
            ),
        ],
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex_test = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex_test) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavouritesPage();
        break;
      case 2:
        page = CheckListHome();
        break;
      default:
        throw UnimplementedError('No Widget for $selectedIndex_test');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            SafeArea(
                child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              destinations: [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text('Favourites')),
                NavigationRailDestination(
                    icon: Icon(Icons.menu_book_outlined),
                    label: Text('CheckList')),
              ],
              selectedIndex: selectedIndex_test,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex_test = value;
                });
              },
            )),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ))
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;

    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavourite();
                  },
                  icon: Icon(icon),
                  label: Text('like')),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'))
            ],
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
