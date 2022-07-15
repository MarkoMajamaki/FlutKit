import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  const SliverPage({Key? key}) : super(key: key);

  static String route = "sliverpage";

  @override
  State<SliverPage> createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  double _availableWidth = 0;
  final double _pinnedToolbarHeight = 50;
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _availableWidth = constraints.maxWidth;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                toolbarHeight: _pinnedToolbarHeight,
                expandedHeight: 250,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('SliverAppBar', textScaleFactor: 1),
                ),
              ),
              SliverFloatingBox(
                pinnedToolBarHeight: _pinnedToolbarHeight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        const Placeholder(),
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
                    if (index == 40) {
                      return Padding(
                        key: dataKey,
                        padding: const EdgeInsets.symmetric(horizontal: 300),
                        child: ListTile(
                          onTap: () {},
                          title: Text('Item scroll ${index + 1}'),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 300),
                        child: ListTile(
                          onTap: () {},
                          title: Text('Item ${index + 1}'),
                        ),
                      );
                    }
                  },
                  childCount: 50,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Scrollable.ensureVisible(dataKey.currentContext!);
            },
            child: const Text("scroll"),
          ),
        );
      },
    );
  }

  Widget _createFloatingButtons() {
    return Column(
      children: [
        ListTile(
          title: const Text("FloatingItem1"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem2"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem3"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem4"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem5"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem6"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem7"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem8"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem9"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem10"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem11"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem12"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem13"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem14"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem15"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("FloatingItem16"),
          onTap: () {},
        ),
      ],
    );
  }
}
