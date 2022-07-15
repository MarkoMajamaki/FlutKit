import 'package:flutkit/flutkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'test2_page.dart';
import '../models/menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  static String route = "menupage";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: SizedBox(
          width: 56,
          height: 56,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              SideBar.of(context).isMenuOpen = !SideBar.of(context).isMenuOpen;
            },
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (_) => MenuModel(),
        child: Consumer<MenuModel>(
          builder: (context, model, child) {
            return ListView.builder(
                itemCount: model.items.length,
                itemBuilder: (context, index) {
                  // Get correct model by index
                  var itemModel = model.items[index];

                  // If model is SeparatorModel, then add separator widget
                  if (itemModel is SeparatorModel) {
                    return const Divider();
                  }
                  // If model is MenuItemModel, then add menu item widget
                  else if (itemModel is MenuItemModel) {
                    MenuItemModel menuItemModel = itemModel;
                    return ListTile(
                      leading: const Icon(Icons.texture),
                      title: Text(menuItemModel.title, maxLines: 1),
                      // subtitle: Text(menuItemModel.subTitle, maxLines: 1),
                      onTap: () {
                        menuItemModel.doSomething();
                        // Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (context) => Test2Screen()));
                        navigatorKey.currentState!.pushNamed(Test2Page.route,
                            arguments:
                                Test2ScreenArguments("Navigated from menu!"));
                      },
                    );
                  }
                  // Else throw exception
                  else {
                    throw Exception("Menu item type is not supported!");
                  }
                });
          },
          child: ListView(),
        ),
      ),
    );
  }
}
