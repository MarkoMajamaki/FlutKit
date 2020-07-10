import 'package:flutter/material.dart';

class SubMenuScreen extends StatefulWidget {
  static String route = "subMenuScreen";
  @override
  _SubMenuScreenState createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Submenu'))
    );
  }
}
