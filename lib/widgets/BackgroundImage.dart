import 'package:flutter/material.dart';


  Widget backgroundImage() {
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ));
  }
