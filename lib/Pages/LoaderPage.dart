import 'package:flutter/material.dart';

class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
