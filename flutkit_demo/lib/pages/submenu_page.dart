import 'package:flutter/material.dart';

class SubMenuPage extends StatefulWidget {
  const SubMenuPage({Key? key}) : super(key: key);

  static String route = "submenupage";

  @override
  State<SubMenuPage> createState() => _SubMenuPageState();
}

class _SubMenuPageState extends State<SubMenuPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Submenu'),
      ),
    );
  }
}
