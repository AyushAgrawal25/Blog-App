import 'package:blogapp/AppTheme.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/Profile/CreateProfile.dart';
import 'package:flutter/material.dart';

import 'MainProfile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = Container(
      alignment: Alignment.center, child: CircularProgressIndicator());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    if (response["status"] == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryThemeColor,
        title: Text(
          "Your Profile",
          textScaleFactor: 1.0,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Color(0xffEEEEFF),
      body: page,
    );
  }

  Widget showProfile() {
    return Center(
        child: Text(
      "Profile Data is Avalable",
      textScaleFactor: 1.0,
    ));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap to button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
            ),
            textScaleFactor: 1.0,
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateProfile()))
            },
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Add Proile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
