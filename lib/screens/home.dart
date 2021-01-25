import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treeForTwo/screens/treePaint.dart';
import 'package:treeForTwo/serivces/saveData.dart';
import 'package:treeForTwo/serivces/saveNameinMobile.dart';
import 'package:treeForTwo/serivces/tree.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String name;
  double top, width;
  String text;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  SaveData saveData = SaveData();
  SaveName saveName = SaveName();
  List<Widget> widgetList = [];
  List<Widget> postionedList = [];
  List<Map> msgList = [];
  List<Widget> pos = [];
  RandomLeaves randomLeaves = RandomLeaves();
  //checking user is new or old
  Future<bool> getUsersname() async {
    print("get user name called");
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        name = preferences.getString("name");
      });
      if (name == null) {
        nameDailogInput();
      }
      getDataFromFirestore();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<Map> setMessageList(
    String name,
    String msg,
    double top,
    double right,
  ) {
    setState(() {
      msgList.add({
        "name": name,
        "msg": msg,
        "top": top,
        "right": right,
      });
    });
    msgPositioned();
    return msgList;
  }

  setWidthAnbdHeight(BuildContext context) {
    setState(() {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
    });
  }

  List<Map> dataList = [];
  List<Map> postioned(double top, double right, String text) {
    print("postioned called");
    setState(() {
      dataList.add({
        "text": text,
        "top": top,
        "right": right,
      });
    });
    postionedWidget();
    return dataList;
  }

  timeCounter() {}

  postionedWidget() {
    print("postioned widget called");
    for (Map m in dataList) {
      print(m);
      setState(() {
        postionedList.add(
          Positioned(
            top: m["top"],
            right: m["right"],
            child: Transform.rotate(
              angle: pi / 1,
              child: AnimatedContainer(
                width: 20.0,
                height: 20.0,
                duration: Duration(seconds: 3),
                child: Image(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    RandomLeaves().getRandomImage(),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  msgPositioned() {
    print("msg postioned called");
    setState(() {
      for (Map m in msgList) {
        pos.add(Positioned(
          bottom: m["top"],
          right: m["right"],
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(title: m["name"], content: Text(m["msg"]));
                },
              );
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/heart.png',
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    m["name"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      textStyle: TextStyle(
                        fontSize: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    m["msg"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      textStyle: TextStyle(
                        fontSize: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    });
  }

  //get data from firestore
  Future<bool> getDataFromFirestore() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("tree_data").get();

      snapshot.docs.forEach((document) => {
            postioned(
              (document.data()["position-height"] is double)
                  ? document.data()["position-height"]
                  : (document.data()["position-height"]).toDouble(),
              (document.data()["position-height"] is double)
                  ? document.data()["position-height"]
                  : (document.data()["position-width"]).toDouble(),
              document.data()["name"],
            ),
            setMessageList(
              document.data()["name"],
              document.data()["msg"],
              (document.data()["heart-position-top"] is double)
                  ? document.data()["heart-position-top"]
                  : document.data()["heart-position-top"].toDouble(),
              (document.data()["heart-position-height"] is double)
                  ? document.data()["heart-position-height"]
                  : document.data()["heart-position-height"].toDouble(),
            ),
          });

      print(dataList);
      print(msgList);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void initState() {
    getUsersname();
    print(name);

    super.initState();
  }

  List<Widget> setWidgetList(BuildContext context) {
    setWidthAnbdHeight(context);
    setState(() {
      widgetList = [
        Container(
          alignment: Alignment.center,
          child: Center(
            child: Image(
              height: screenHeight / 1,
              width: screenWidth / 1.1,
              image: AssetImage("assets/tree.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          child: Stack(
            children: postionedList,
          ),
        ),
        Container(
          child: Stack(
            children: pos,
          ),
        )
      ];
    });
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    //print(dataList);
    getDataFromFirestore();
    return Scaffold(
      body: InteractiveViewer(
        maxScale: 10.0,
        child: Stack(
          children: setWidgetList(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                print(context);
                return SingleChildScrollView(
                  child: AlertDialog(
                    title: Text(
                      "Hello",
                      style: titleTextStyles(),
                    ),
                    content: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 3.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: nameController,
                              style: smallTextStyles(),
                            ),
                            TextFormField(
                              controller: msgController,
                              style: smallTextStyles(),
                            ),
                            InkWell(
                              onTap: () {
                                saveData.setDataInFirestore(
                                  nameController.text,
                                  msgController.text,
                                  MediaQuery.of(context).size.width,
                                );
                                saveName.saveNameInMobile(
                                  nameController.text,
                                );
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3.0,
                                height:
                                    MediaQuery.of(context).size.height / 14.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.pink[200],
                                      Colors.pink[100],
                                    ],
                                  ),
                                ),
                                child: Text(
                                  "Let's see it",
                                  style: smallTextStyles(),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              });
        },
        child: Icon(
          Icons.favorite,
          color: Colors.pink[200],
          size: 30.0,
        ),
        backgroundColor: Colors.pink,
      ),
    );
  }

  // getting the name and message from alet dailog
  TextEditingController nameController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  nameDailogInput() {
    print("show dailog called");
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          print(context);
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                "Hello",
                style: titleTextStyles(),
              ),
              content: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 3.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: smallTextStyles(),
                      ),
                      TextFormField(
                        controller: msgController,
                        style: smallTextStyles(),
                      ),
                      InkWell(
                        onTap: () {
                          saveData.setDataInFirestore(
                            nameController.text,
                            msgController.text,
                            MediaQuery.of(context).size.width,
                          );
                          saveName.saveNameInMobile(
                            nameController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.0,
                          height: MediaQuery.of(context).size.height / 14.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink[200],
                                Colors.pink[100],
                              ],
                            ),
                          ),
                          child: Text(
                            "Let's see it",
                            style: smallTextStyles(),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  TextStyle smallTextStyles() {
    return GoogleFonts.ubuntu(
        textStyle: TextStyle(
      color: Colors.pink[900],
      fontSize: MediaQuery.of(context).size.width / 18.0,
      fontWeight: FontWeight.w600,
    ));
  }

// text style for title text
  TextStyle titleTextStyles() {
    return GoogleFonts.ubuntu(
        textStyle: TextStyle(
      color: Colors.pink[900],
      fontSize: MediaQuery.of(context).size.width / 12.0,
      fontWeight: FontWeight.bold,
    ));
  }
}

// widget list

//text styles for small texts
