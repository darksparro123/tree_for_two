import 'package:randomizer/randomizer.dart';

class RandomLeaves {
  List<String> images = [
    "assets/h1.png",
    "assets/h2.png",
    "assets/h3.png",
    "assets/h4.png",
    "assets/h5.png"
  ];
  Randomizer randomizer = Randomizer();
  String getRandomImage() {
    String randomImage = randomizer.getrandomelementfromlist(images);
    print(randomImage);
    return randomImage;
  }
}

class GetRandomPositions {
  Randomizer randomizer = Randomizer();
  getRabdomPositionWidth(double screenWidth) {
    int width = randomizer.getrandomnumber(
        (screenWidth / 2.3).round(), (screenWidth / 2).round());
    return width.toDouble();
  }

  double getRabdomPositionHeight(double screenWidth) {
    int a = randomizer.getrandomnumber(
        (screenWidth / 6).round(), (screenWidth / 2.3).round());
    return a.toDouble();
  }
}
