import "dart:math";

class Tree {
  String getLeaves() {
    var list = ['leaf 1', 'leaf 2', 'leaf 3', 'leaf 5', 'leaf 5'];
    var a = list[Random().nextInt(list.length)];
    return a;
  }
}
