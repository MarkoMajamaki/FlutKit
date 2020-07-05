import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_screen.dart';
import 'submenu_screen.dart';
import 'test1_screen.dart';
import '../widgets/sidebar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SideBarController _sideBarController;
  SideBar sideBar;

  @override
  void initState() {
    _sideBarController = SideBarController();
    sideBar = SideBar();
  }

  @override
  void dispose() {
    _sideBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          _sideBarController.isMenuOpen(model.isMenuOpen);
          _sideBarController.isSubMenuOpen(model.isSubMenuOpen);
          return child;
        },
        // Tablet test value
        child: SideBar(
          controller: _sideBarController,
          content: Test1Screen(),
          menu: MenuScreen(),
          submenu: SubMenuScreen(),
          menuWidth: 230,
          subMenuWidth: 250,
          menuSpacing: 64,
          contentBehavior: ContentBehavior.Resize,
          menuOpenMode: MenuOpenMode.Floating,
          menuCloseMode: MenuCloseMode.Narrow,
          subMenuOpenMode: SubMenuOpenMode.Default,
          verticalSeparatorThickness: 1,
          verticalSeparatorColor: Colors.black12,
        ),
      ),
    );
  }
}

class HomeModel extends ChangeNotifier {
  bool isMenuOpen = false;
  bool isSubMenuOpen = false;

  void openMenu() {
    isMenuOpen = true;
    notifyListeners();
  }

  void closeMenu() {
    isMenuOpen = false;
    notifyListeners();
  }

  void openSubMenu() {
    isSubMenuOpen = true;
    notifyListeners();
  }

  void closeSubMenu() {
    isSubMenuOpen = false;
    notifyListeners();
  }
}
