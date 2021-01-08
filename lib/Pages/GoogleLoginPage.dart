import 'dart:convert';

import 'package:blogapp/AppTheme.dart';
import 'package:blogapp/BusinessLogic/AuthProvider.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/LoaderPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;

class GoogleLoginPage extends StatefulWidget {
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return Container(
      child: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: Container(
          child: Stack(
            children: [
              // Main Code
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 10,
                                          width: 120,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          color: Colors.deepPurple.shade600),

                                      // Name
                                      Container(
                                        child: Text(
                                          "Uped",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 35,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                      Container(
                                          height: 10,
                                          width: 120,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          color: Colors.deepPurple.shade600),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Sign up",
                                    style: GoogleFonts.roboto(
                                        fontSize: 22.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                    textScaleFactor: 1.0,
                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),
                                // Buttom
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(360),
                                    onTap: onGoogleLogin,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 15,
                                                spreadRadius: 0.5,
                                                offset: Offset(10, 10),
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.1))
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(360)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 22.5,
                                            child: Image.asset(
                                              "assets/google.png",
                                              height: 22.5,
                                              width: 22.5,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Google",
                                                style: GoogleFonts.nunito(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87),
                                                textScaleFactor: 1.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15),
                      ],
                    ),
                  ),
                ),
              ),

              // Loader
              (isLoading)
                  ? Container(
                      child: LoaderPage(),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    )
            ],
          ),
        ),
      ),
    );
  }

  onGoogleLogin() async {
    NetworkHandler networkHandler = NetworkHandler();
    final storage = new FlutterSecureStorage();
    // Loader Start
    setState(() {
      isLoading = true;
    });

    bool status = await AuthProvider().loginWithGoogle();
    print("Google Login Status : $status");

    fAuth.User currentUser = await AuthProvider().getCurrentUser();
    List<String> emailParts = currentUser.email.split("@gmail.com");

    bool isRegistered = false;
    var userNameRegResp =
        await networkHandler.get("/user/checkUsername/${emailParts[0]}");
    if (userNameRegResp['Status']) {
      isRegistered = true;
    } else {
      isRegistered = false;
    }

    if (!isRegistered) {
      // we will send the data to rest server
      Map<String, String> data = {
        "username": emailParts[0],
        "email": currentUser.email,
        "password": currentUser.uid,
      };
      print(data);
      var responseRegister = await networkHandler.post("/user/register", data);
      if (responseRegister.statusCode == 200 ||
          responseRegister.statusCode == 201) {
        isRegistered = true;
      }
    }

    if (isRegistered) {
      Map<String, String> data = {
        "username": emailParts[0],
        "password": currentUser.uid,
      };
      var response = await networkHandler.post("/user/login", data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        print(output["token"]);
        await storage.write(key: "token", value: output["token"]);

        // Loader End
        setState(() {
          isLoading = false;
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Netwok Error")));
      }
    } else {
      // Loader End
      setState(() {
        isLoading = false;
      });
    }
  }
}
