import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class SliverScreen extends StatefulWidget {
  static String route = "SliverScreen";

  SliverScreen({Key? key}) : super(key: key);

  @override
  _SliverScreenState createState() => _SliverScreenState();
}

class _SliverScreenState extends State<SliverScreen> {
  double _availableWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _availableWidth = constraints.maxWidth;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                toolbarHeight: 50,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('SliverAppBar', textScaleFactor: 1),
                ),
              ),
              SliverFloatingBox(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Positioned(
                          width: 300,
                          height: constraints.maxHeight,
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: SingleChildScrollView(
                              child: _createFloatingButtons(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: _availableWidth - 300,
                          width: 300,
                          height: constraints.maxHeight,
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: SingleChildScrollView(
                              child: _createFloatingButtons(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 300),
                      child: ListTile(
                        onTap: () {},
                        title: Text('Item ${index + 1}'),
                      ),
                    );
                  },
                  childCount: 50,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _createFloatingButtons() {
    return Column(
      children: [
        ListTile(
          title: Text("FloatingItem1"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem2"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem3"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem4"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem5"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem6"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem7"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem8"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem9"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem10"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem11"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem12"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem13"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem14"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem15"),
          onTap: () {},
        ),
        ListTile(
          title: Text("FloatingItem16"),
          onTap: () {},
        ),
      ],
    );
  }
}
