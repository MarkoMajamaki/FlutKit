import 'package:flutkit/flutkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/rendering.dart';

class LayoutScreen extends StatefulWidget {
  static String route = "layoutScreen";
  LayoutScreen({Key key}) : super(key: key);

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WrapLayout',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              WrapLayout(
                columnWidth: 100,
                columnSpacing: 10,
                rowSpacing: 10,
                children: [
                  _button("1", 100, Colors.green),
                  _button("2", 100, Colors.red)
                      .withWrapPlacement(columnSpan: 3),
                  _button("3", 100, Colors.blue)
                      .withWrapPlacement(fillRow: true),
                  _button("4", 100, Colors.yellow),
                  _button("5", 100, Colors.purple),
                  _button("6", 100, Colors.purple),
                  _button("7", 100, Colors.green)
                      .withWrapPlacement(rowStart: true),
                  _button("8", 100, Colors.black),
                ],
              ),
              Container(height: 10, color: Colors.transparent),
              WrapLayout(
                orientation: WrapOrientation.Vertical,
                columnWidth: 100,
                columnSpacing: 10,
                rowSpacing: 10,
                children: [
                  _button("1", 100, Colors.red),
                  _button("2", 100, Colors.blue),
                  _button("3", 100, Colors.yellow),
                  _button("4", 100, Colors.green),
                  _button("5", 100, Colors.black),
                  _button("6", 100, Colors.purple)
                      .withWrapPlacement(fillRow: true),
                  _button("7", 100, Colors.green),
                  _button("8", 100, Colors.black),
                ],
              ),
              Container(height: 10, color: Colors.transparent),
              WrapLayout(
                orientation: WrapOrientation.Horizontal,
                columnMinWidth: 120,
                columnSpacing: 10,
                rowSpacing: 10,
                children: [
                  _button("1", 100, Colors.red),
                  _button("2", 100, Colors.blue),
                  _button("3", 100, Colors.yellow),
                  _button("4", 100, Colors.green),
                  _button("5", 100, Colors.black),
                  _button("6", 100, Colors.purple)
                      .withWrapPlacement(fillRow: true),
                  _button("7", 100, Colors.green),
                  _button("8", 100, Colors.black),
                ],
              ),
              Container(height: 10, color: Colors.transparent),
              WrapLayout(
                orientation: WrapOrientation.Vertical,
                columnMinWidth: 120,
                columnSpacing: 10,
                rowSpacing: 10,
                children: [
                  _button("1", 100, Colors.red),
                  _button("2", 100, Colors.blue),
                  _button("3", 100, Colors.yellow),
                  _button("4", 100, Colors.green),
                  _button("5", 100, Colors.black),
                  _button("6", 100, Colors.purple)
                      .withWrapPlacement(fillRow: true),
                  _button("7", 100, Colors.green),
                  _button("8", 100, Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String text, double height, Color color) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FlatButton(
        color: color,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.blueAccent,
        onPressed: () {
          /*...*/
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
