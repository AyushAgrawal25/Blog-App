import 'dart:convert';

import 'package:blogapp/BusinessLogic/AuthProvider.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:blogapp/Pages/LoaderPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLogin = false;
  Map data;
  final facebookLogin = FacebookLogin();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

// animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Container(
            child: Scaffold(
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green[200]],
                    begin: const FractionalOffset(0.0, 1.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.repeated,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SlideTransition(
                        position: animation1,
                        child: Text(
                          "Uped",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.125,
                      ),
                      SlideTransition(
                        position: animation1,
                        child: Text(
                          "Great stories for great people",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 38,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      boxContainer(
                          "assets/google.png", "Google", onGoogleLogin),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // boxContainer(
                      //     "assets/facebook1.png", "Sign up with Facebook", onFBLogin),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // boxContainer(
                      //   "assets/email2.png",
                      //   "Sign up with Email",
                      //   onEmailClick,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

  // onEmailClick() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => SignUpPage(),
  //   ));
  // }

  Widget boxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 140,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Image.asset(
                      path,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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
      ),
    );
  }
}
