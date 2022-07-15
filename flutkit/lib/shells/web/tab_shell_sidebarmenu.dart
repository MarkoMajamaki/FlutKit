import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class TabShellSideBarMenu extends StatelessWidget {
  const TabShellSideBarMenu({
    Key? key,
    required this.tabs,
    required this.tabController,
  }) : super(key: key);

  final List<TabDefinition> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List<Widget>.generate(
            tabs.length,
            (index) => TextButton(
              onPressed: () {
                tabController.index = index;
                SideBar.of(context).isMenuOpen = false;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  tabs[index].text,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
