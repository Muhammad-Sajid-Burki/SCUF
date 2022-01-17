import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/Institutes%20Detailes/CollegeDetailsScreen.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/Institutes%20Detailes/SchoolDetailsScreen.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/Institutes%20Detailes/UniversityDetailsPage.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/ScufCards/CollegeCard.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/ScufCards/UniversityCard.dart';
import 'package:flutter_web_to_app_design/Screens/Student/StudentSignIn.dart';
import 'package:flutter_web_to_app_design/widgets/Drawer.dart';
import 'package:flutter_web_to_app_design/widgets/colors.dart';
import 'ScufCards/SchoolCard.dart';

class InstitutesScreen extends StatefulWidget {
  @override
  State<InstitutesScreen> createState() => _InstitutesScreenState();
}

class _InstitutesScreenState extends State<InstitutesScreen> {
  CollectionReference schools = FirebaseFirestore.instance
      .collection("Institutes")
      .doc('data')
      .collection('School');

  CollectionReference college = FirebaseFirestore.instance
      .collection("Institutes")
      .doc('data')
      .collection('College');

  CollectionReference university = FirebaseFirestore.instance
      .collection("Institutes")
      .doc('data')
      .collection('University');

  List categories = ['ALL',  'School', 'College', 'University'];
  int selectedIndex = 0;

  TextEditingController searchTextController = TextEditingController();

  var searchString = "";

  final user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,

      drawer: user == null ? null : Drawer(child: MyDrawer()),
      body: SafeArea(
          bottom: false,
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(kDefaultPadding),
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 4, // 5 top and bottom
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                    print(searchString);
                  });
                },
                controller: searchTextController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: SvgPicture.asset(
                    "assets/icons/search.svg",
                    color: Colors.white,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      print(selectedIndex);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: kDefaultPadding,
                      // At end item it add extra 20 right  padding
                      right:
                          index == categories.length - 1 ? kDefaultPadding : 0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Colors.white.withOpacity(0.4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: kDefaultPadding / 2),
            Expanded(
              child: Stack(
                children: <Widget>[
                  // Our background
                  Container(
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  selectedIndex == 0 ?
                  StreamBuilder<QuerySnapshot>(
                          stream: (searchString != "" && searchString != null)
                      ? schools.where('School Name', isEqualTo: searchTextController.text).snapshots()
                          : schools.snapshots(),
                          builder: (context, snapshot) {
                            return (snapshot.connectionState == ConnectionState.waiting)
                              ? Center( child:  CircularProgressIndicator(),) :
                             ListView.builder(
                                // here we use our demo procuts list
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot course =
                                      snapshot.data!.docs[index];

                                  print(course);
                                  return
                                    SchoolCard(
                                    course: course,
                                    press: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SchoolDetailsScreen(
                                            course: course,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                        )
                      : selectedIndex == 1 ?
                  StreamBuilder<QuerySnapshot>(
                              stream: (searchString != "" && searchString != null)
                                  ? college.where('College Name', isEqualTo: searchTextController.text).snapshots()
                                  : college.snapshots(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState == ConnectionState.waiting)
                          ? Center( child:  CircularProgressIndicator(),) : ListView.builder(
                                    // here we use our demo procuts list
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot course =
                                          snapshot.data!.docs[index];
                                      return CollegeCard(
                                        course: course,
                                        press: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CollegeDetailsScreen(
                                                course: course,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: (searchString != "" && searchString != null)
                                  ? university.where('University Name', isEqualTo: searchTextController.text).snapshots()
                                  : university.snapshots(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState == ConnectionState.waiting)
                          ? Center( child:  CircularProgressIndicator(),) : ListView.builder(
                                    // here we use our demo procuts list
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot course =
                                          snapshot.data!.docs[index];
                                      return UniversityCard(
                                        course: course,
                                        press: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UniversityDetailsScreen(
                                                course: course,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                            ),
                ],
              ),
            )
          ])),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Center(
          child: Text(
        'Institutes',
        style: TextStyle(fontSize: 25),
      )),
      actions: user == null ? null :  <Widget>[
         PopupMenuButton<String>(
          child: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'signOut',
              child: Text('Sign Out'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'signOut':
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => StudentSignIn()));
            }
          },
        ),
      ],
    );
  }

}
