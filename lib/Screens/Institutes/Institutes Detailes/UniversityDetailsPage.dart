import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_to_app_design/widgets/colors.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../Screens/Institutes/Institutes Detailes/ScufImage.dart';

class UniversityDetailsScreen extends StatelessWidget {
  DocumentSnapshot? course;

  UniversityDetailsScreen({Key? key, this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // it provide us total height and width
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small devices
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: buildAppBar(context),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Hero(
                        tag: '${course!['University Name']}',
                        child: ProductPoster(
                          size: size,
                          image: course!['University Image'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2),
                      child: Text(
                        course!['University Name'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Text(
                      '${course!['Sector']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kSecondaryColor,
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                      child: Text(
                        course!['University Address'],
                        style: TextStyle(color: kTextLightColor),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                  ],
                ),
              ),
              infoContainer("Contact No : ${course!['Contact no']}", Icons.phone),
              infoContainer("Email : ${course!['Email']}", Icons.email),
              infoContainer("Fields : ${course!['Fields']}", Icons.subject),
              infoContainer("Percentage : ${course!['Percentage of Marks']}%", Icons.credit_score),
              infoContainer("Link : ${course!['Link']}", Icons.link),
              InkWell(
                  onTap: () {
                    openFile(url: course!['Fee Structure']);
                    },
                  child: infoContainer("Fee Structure", Icons.description_outlined)),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoContainer( String text, IconData iconData){
    return Container(
      constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 400
      ),
      height: 70,
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          Icon(iconData, color: Colors.white,),
          SizedBox(width: kDefaultPadding ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // it will cover all available spaces

        ],
      ),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        'Back'.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await downloadFile(url, name);

    if(file == null) return;
    print('Path : ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    // var httpsReference = course!['Fee Structure'];
    //
    // Set fileName = httpsReference.name;

    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
          url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }


}


