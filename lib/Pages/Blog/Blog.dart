import 'package:blogapp/Pages/Blog/BlogsCategories.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Blog extends StatelessWidget {
  const Blog({Key key, this.addBlogModel, this.networkHandler})
      : super(key: key);
  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: Container(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                addBlogModel.title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                textScaleFactor: 1.0,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: ListView(
              children: [
                Card(
                  elevation: 0.1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: networkHandler.getImage(addBlogModel.id),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            addBlogModel.title,
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                addBlogModel.comment.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.thumb_up,
                                size: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                (addBlogModel.count == null)
                                    ? "0"
                                    : addBlogModel.count.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.share,
                                size: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                addBlogModel.share.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        // Category
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            blogCategories[addBlogModel.categoryId],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // User Name
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Posted by : " + addBlogModel.username,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 5,
                  ),
                  child: Text(
                    addBlogModel.body,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
