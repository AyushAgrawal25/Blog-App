import 'package:blogapp/AppTheme.dart';
import 'package:blogapp/Pages/Blog/Blogs.dart';
import 'package:blogapp/Pages/Blog/addBlog.dart';
import 'package:blogapp/BusinessLogic/AuthProvider.dart';
import 'package:blogapp/Pages/GoogleLoginPage.dart';
import 'package:blogapp/Pages/LoaderPage.dart';
import 'package:blogapp/Pages/LoadingPage.dart';
import 'package:blogapp/Pages/Search/BlogSearchPage.dart';
import 'package:blogapp/Pages/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/NetworkHandler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String username = "";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response["status"] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text("@$username"),
                ],
              ),
            ),
            // ListTile(
            //   title: Text("All Post"),
            //   trailing: Icon(Icons.launch),
            //   onTap: () {},
            // ),
            // ListTile(
            //   title: Text("New Story"),
            //   trailing: Icon(Icons.add),
            //   onTap: () {},
            // ),
            // ListTile(
            //   title: Text("Settings"),
            //   trailing: Icon(Icons.settings),
            //   onTap: () {},
            // ),
            // ListTile(
            //   title: Text("Feedback"),
            //   trailing: Icon(Icons.feedback),
            //   onTap: () {},
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.power_settings_new),
                onTap: logout,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appPrimaryThemeColor,
        title: Text("Uped"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return BlogSearchPage(
                      networkHandler: networkHandler,
                    );
                  },
                ));
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: appPrimaryThemeColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: appPrimaryThemeColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 25,
                  ),
                  color: Colors.white,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    size: 27.5,
                  ),
                  color: Colors.white54,
                  onPressed: () {
                    // setState(() {
                    //   currentState = 1;
                    // });
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen();
                      },
                    ));
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xffEEEEFF),
      body: Container(
        child: SingleChildScrollView(
          child: Blogs(
            url: "/blogpost/getOtherBlog",
          ),
        ),
      ),
    );
  }

  void logout() async {
    await AuthProvider().googleSignOut();
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => GoogleLoginPage()),
        (route) => false);
  }
}
