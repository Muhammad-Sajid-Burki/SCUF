import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/InstitutesScreen.dart';
import 'package:flutter_web_to_app_design/Screens/ScufSelectPage.dart';
import 'package:flutter_web_to_app_design/Screens/Student/StudentSignIn.dart';
import 'package:flutter_web_to_app_design/Screens/Student/StudentSignUp.dart';
import 'package:flutter_web_to_app_design/widgets/BackgroundImage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io' show Platform;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _selection;

  final List<String> imgList = const [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'

  ];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList.map((item) =>
        Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.cover, width: 1000.0),
                ],
              ),
            ),
          ),
        ))
        .toList();

    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: [
            backgroundImage(),
            Positioned(
                right: 10,
                top: 50,
                child: popupmenu()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    child: Stack(
                      children: [
                        ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: const Text("SCUF", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),),
                            ),
                            title: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.search)),
                            trailing: InkWell(
                              onTap: () {
                                selectionDialog();

                              },
                              child: Container(
                                height: 20,
                                width: 80,

                                child: Center(child: Text("GET STARTED",
                                  style: TextStyle(fontSize: 10,),)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.red
                                ),
                              ),
                            )
                        ),

                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => StudentSignUp()));
                      },
                      child: Text("SCUF", style: TextStyle(color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Text("School/ College/ University Finder",
                      style: TextStyle(color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: GestureDetector(
                      onTap: () {
                        selectionDialog();
                      },
                      child: Container(
                        height: 50,
                        width: 150,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.trip_origin_outlined,
                              color: Theme.of(context).accentColor,
                              size: 30,
                            ),
                            Text("GET STARTED", style: TextStyle(fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.grey),
                            color: Colors.black87
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: Platform.isIOS ? 300 : 200,
              right: 0,
              left: 0,
              child: Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => InstitutesScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Skip this", style: TextStyle(fontSize: 25, decoration: TextDecoration.underline,),),
                    Text(">>>", style: TextStyle(fontSize: 30),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget popupmenu() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selection = value;
        });
      },
      child: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'home',
          child: Text('HOME'),
        ),
        const PopupMenuItem<String>(
          value: 'about us',
          child: Text('ABOUT US'),
        ),
        const PopupMenuItem<String>(
          value: 'help',
          child: Text('HELP'),
        ),
      ],
    );
  }

  void selectionDialog() {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Select", textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      StudentmodeDialog("Student Mode");
                    },
                    child: Text(
                      "Continue as Student Mode", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      InstitutemodeDialog("Institute Mode");
                    },
                    child: Text(
                      "Continue as Institute Mode", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }


    void StudentmodeDialog(String text) {
      showDialog(
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 200,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      text, textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => StudentSignUp()));
                      },
                      child: Text(
                        "Sign Up", textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18,),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => StudentSignIn()));
                      },
                      child: Text(
                        "Sign In", textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18,),),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        context: context,
      );
    }

  void InstitutemodeDialog(String text) {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    text, textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => SCUFSelectPage()));
                    },
                    child: Text(
                      "Sign Up", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => SCUFSelectPage()));
                    },
                    child: Text(
                      "Sign In", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }
  }

