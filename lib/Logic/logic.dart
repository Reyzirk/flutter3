import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/Objects/objects.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favourites = <WordPair>[];
  var checkListArr = <CheckList>[];
  var checkListCount = 0;

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