import 'package:flutter/material.dart';
import 'package:namer_app/Screens/checklist.dart';
import 'package:namer_app/Screens/favourites.dart';
import 'package:namer_app/Screens/homescreen.dart';

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