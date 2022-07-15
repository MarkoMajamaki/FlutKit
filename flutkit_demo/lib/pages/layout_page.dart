import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  static String route = "layouts";

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WrapLayout',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IntrinsicHeight(
              child: WrapLayout(
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
            ),
            Container(height: 10, color: Colors.transparent),
            WrapLayout(
              orientation: WrapOrientation.vertical,
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
              orientation: WrapOrientation.horizontal,
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
              orientation: WrapOrientation.vertical,
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
            Container(
              height: 100,
              width: 100,
              color: Colors.transparent,
            ),
            Center(
              child: WrapLayout(
                orientation: WrapOrientation.horizontal,
                columnMinWidth: 120,
                columnSpacing: 10,
                rowSpacing: 10,
                children: [
                  _button("1", 100, Colors.red),
                  _button("2", 100, Colors.blue),
                  _button("3", 100, Colors.yellow)
                      .withWrapPlacement(rowEnd: true),
                  _button("4", 100, Colors.green),
                  _button("5", 100, Colors.black)
                      .withWrapPlacement(rowStart: true),
                  _button("6", 100, Colors.purple),
                  _button("7", 100, Colors.green),
                  _button("8", 100, Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, double height, Color color) {
    return Container(
      width: double.infinity,
      height: height,
      color: color.withOpacity(0.5),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
