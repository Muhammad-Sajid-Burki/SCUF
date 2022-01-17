import 'package:flutter/material.dart';
import 'package:flutter_web_to_app_design/AuthServices/AuthServices.dart';
import 'package:flutter_web_to_app_design/Model/Users.dart';
import 'package:flutter_web_to_app_design/Screens/HomePage.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/InstitutesScreen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthService>(context);

    return StreamBuilder<Users?>(
        stream: authServices.user,
        builder: (context, AsyncSnapshot<Users?> snapshot){
          if( snapshot.connectionState == ConnectionState.active){
            final Users? users = snapshot.data;
            return users == null ? HomePage() : InstitutesScreen();
          }
          else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
