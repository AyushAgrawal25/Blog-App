import 'package:blogapp/Pages/Blog/Blogs.dart';
import 'package:blogapp/Model/SuperModel.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/Model/profileModel.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/CustomWidget/BlogCard.dart';
import 'package:blogapp/Pages/Blog/Blog.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    super.initState();

    fetchData();
    fetchBlogsData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  List<AddBlogModel> yourBlogsData = [];
  fetchBlogsData() async {
    var response = await networkHandler.get("/blogpost/getOwnBlog");
    SuperModel superModel = SuperModel();
    superModel = SuperModel.fromJson(response);
    setState(() {
      yourBlogsData = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return circular
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              head(),
              Divider(
                thickness: 0.8,
              ),
              otherDetails("About", profileModel.about),
              otherDetails("Name", profileModel.name),
              otherDetails("Profession", profileModel.profession),
              otherDetails("DOB", profileModel.DOB),
              Divider(
                thickness: 0.8,
              ),
              SizedBox(
                height: 20,
              ),
              // Blogs(
              //   url: "/blogpost/getOwnBlog",
              // ),

              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: yourBlogsData
                      .map((item) => Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) => Blog(
                                                addBlogModel: item,
                                                networkHandler: networkHandler,
                                              )));
                                },
                                child: BlogCard(
                                  addBlogModel: item,
                                  networkHandler: networkHandler,
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              )
            ],
          );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(profileModel.username),
            ),
          ),
          Text(
            profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textScaleFactor: 1.0,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            profileModel.titleline,
            textScaleFactor: 1.0,
          )
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.0,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
            textScaleFactor: 1.0,
          )
        ],
      ),
    );
  }
}
