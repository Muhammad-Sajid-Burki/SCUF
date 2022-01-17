import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_to_app_design/Screens/SCUF%20Registeration/CollegeRegisteration.dart';
import 'package:flutter_web_to_app_design/Screens/SCUF%20Registeration/SchoolRegisteration.dart';
import 'package:flutter_web_to_app_design/Screens/SCUF%20Registeration/UniversityRegisteration.dart';
import 'package:flutter_web_to_app_design/widgets/BackgroundImage.dart';
import 'package:carousel_slider/carousel_slider.dart';


class SCUFSelectPage extends StatefulWidget {
  const SCUFSelectPage({Key? key}) : super(key: key);

  @override
  _SCUFSelectPageState createState() => _SCUFSelectPageState();
}

class _SCUFSelectPageState extends State<SCUFSelectPage> {



  @override
  Widget build(BuildContext context) {

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => SchoolRegisteration()));
                        },
                        child: scufTypes("School", "assets/school.png")),
                    SizedBox(height: 20,),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => CollegeRegisteration()));
                        },
                        child: scufTypes("College", "assets/college.png")),
                    SizedBox(height: 20,),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => UniversityRegisteration()));
                        },
                        child: scufTypes("University", "assets/university.png")),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget scufTypes(String name, image) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black38,

        ),
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 120,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,

                ),
                child: Center(
                  child: Container(
                      height: 100,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: Image.asset(image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
            )
          ],
        )
    );
  }

}

