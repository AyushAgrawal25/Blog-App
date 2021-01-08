import 'package:blogapp/CustomWidget/BlogCard.dart';
import 'package:blogapp/Model/SuperModel.dart';
import 'package:blogapp/Model/addBlogModels.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/Blog/Blog.dart';
import 'package:blogapp/Pages/LoaderPage.dart';
import 'package:flutter/material.dart';

class BlogSearchPage extends StatefulWidget {
  NetworkHandler networkHandler;
  BlogSearchPage({this.networkHandler});
  @override
  _BlogSearchPageState createState() => _BlogSearchPageState();
}

class _BlogSearchPageState extends State<BlogSearchPage> {
  TextEditingController searchTextController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchTextController = TextEditingController();
  }

  SuperModel superModel = SuperModel();

  int nofAPICalls = 0;
  List<AddBlogModel> searchedBlogs = [];
  String lastSearchedText = "";
  searchBlogs() async {
    if (searchTextController.text != lastSearchedText) {
      nofAPICalls++;
      var response = await widget.networkHandler.get("/blogpost/getOtherBlog");
      superModel = SuperModel.fromJson(response);
      setState(() {
        searchedBlogs = superModel.data;
      });
      nofAPICalls--;
      lastSearchedText = searchTextController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Search Blogs",
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
          body: Container(
            child: Column(
              children: [
                // Search Bar
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.5, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: searchTextController,
                              style: TextStyle(
                                fontSize:
                                    15 / MediaQuery.of(context).textScaleFactor,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 27.5),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(360),
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 1.5))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(360),
                            child: Container(
                              width: 47.5,
                              height: 47.5,
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(360)),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            onTap: searchBlogs,
                          ),
                        )
                      ],
                    )),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: (nofAPICalls > 0)
                        ? LoaderPage()
                        : Container(
                            child: (searchedBlogs.length > 0)
                                ? ListView.builder(
                                    itemCount: searchedBlogs.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        height:
                                            (MediaQuery.of(context).size.width -
                                                    40) *
                                                3 /
                                                4,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (contex) => Blog(
                                                          addBlogModel:
                                                              searchedBlogs[
                                                                  index],
                                                          networkHandler: widget
                                                              .networkHandler,
                                                        )));
                                          },
                                          child: BlogCard(
                                            addBlogModel: searchedBlogs[index],
                                            networkHandler:
                                                widget.networkHandler,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text("No Blogs Found."),
                                  )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
