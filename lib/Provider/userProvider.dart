import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_to_app_design/Model/userModel.dart';

class UserProvider with ChangeNotifier {
  void addUserData({
    User? currentUser,
    String? userName,
    String? email,
    String? gender,
    String? dob,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .set(
      {
        "UserName": userName,
        "Email": email,
        "Gender": gender,
        "date of Birth": dob,
        "userUid": currentUser.uid,
      },
    );
  }

  UserModel? currentData;

  void getUserData() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        email: value.get("Email"),
        gender: value.get("Gender"),
        userName: value.get("UserName"),
        dob: value.get("date of Birth"),
        userUid: value.get("userUid"),
      );
      currentData = userModel;
      notifyListeners();
    }
  }

  UserModel? get currentUserData {
    return currentData;
  }
}