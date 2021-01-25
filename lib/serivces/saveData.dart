import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treeForTwo/screens/treePaint.dart';
import 'package:treeForTwo/serivces/tree.dart';

class SaveData {
  final firebase = FirebaseFirestore.instance;
  GetRandomPositions getRandomPostions = GetRandomPositions();
  double getRandomPostionedHeight() {
    int max = 520;
    double randomNumber = (Random().nextInt(max) + 1).toDouble();
    return randomNumber;
  }

  double getRandomPostionedWidth() {
    int max = 300;
    double randomNumber = (Random().nextInt(max) + 1).toDouble();
    return randomNumber;
  }

  Future<bool> setDataInFirestore(
      String name, String msg, double screenWidth) async {
    String leaf = Tree().getLeaves();
    try {
      await firebase.collection("tree_data").doc().set(
        {
          "name": name,
          "msg": msg,
          "leaf": leaf,
          "date": DateTime.now().toString().substring(0, 16),
          "position-width": getRandomPostionedWidth(),
          "position-height": getRandomPostionedHeight(),
          "heart-position-height":
              getRandomPostions.getRabdomPositionWidth(screenWidth),
          "heart-position-top":
              getRandomPostions.getRabdomPositionHeight(screenWidth),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
