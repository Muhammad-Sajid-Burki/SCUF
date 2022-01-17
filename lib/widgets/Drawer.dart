import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String? myEmail;
  String? gender;
  String? userName;
  String? dob;



  _fetch() async {
    final firebaseUser =  FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myEmail = ds.data()!['Email'];
        userName = ds.data()!['UserName'];
        dob = ds.data()!['date of Birth'];
        gender = ds.data()!['Gender'];
      });
  }

  @override
  void initState() {
    _fetch();
    print('This is my email $myEmail');
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done)
            return Text("Loading data.. Please Wait");
          return Drawer(
            child: Container(

              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Theme
                                  .of(context)
                                  .accentColor,
                              Colors.red.shade200,
                            ],
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.centerLeft,
                            end: FractionalOffset.centerRight,
                            tileMode: TileMode.repeated
                        )
                    ),
                    padding: EdgeInsets.zero,
                    child: UserAccountsDrawerHeader(
                      margin: EdgeInsets.zero,
                      accountEmail: Text(
                        myEmail!,
                      ),
                      accountName: Text(userName!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage(""),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dashboard,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "Dashboard",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "Chatting",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "Settings",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor,
                      ),
                    ),
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "Profile",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.developer_mode,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "About",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    title: Text(
                      "Contact",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      
      


  }
}