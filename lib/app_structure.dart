import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'constants/constants.dart';
import 'pages/home_page.dart';
import 'pages/product_page.dart';

class AppStructure extends StatefulWidget {
  @override
  _AppStructureState createState() => _AppStructureState();
}

class _AppStructureState extends State<AppStructure> {
  int _selectedIndex = 0;

  final itemNames = <_Item>[
    _Item('首页', Icons.home),
    _Item('产品', Icons.language),
    _Item('行程', Icons.trip_origin),
    _Item('我的', Icons.face),
  ];

  List<BottomNavigationBarItem> get _itemList {
    return itemNames
        .map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon, color: ColorConstants.NORMAL),
            title: Text(item.name),
            activeIcon: Icon(item.icon, color: ColorConstants.ACTIVE)))
        .toList();
  }


  List<Widget> _pages = <Widget>[
    HomePage(),
    ProductsPage(),
    Text('Journey'),
    Text(
      'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        title: Image.asset(Constants.STATIC_IMG + 'logo-icon.png', width: 80),
        title: Image.asset(Constants.STATIC_IMG + 'logo.jpg', width: 120,),
        centerTitle: true,
        elevation: 0,
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _itemList,
        currentIndex: _selectedIndex,
        selectedItemColor: ColorConstants.ACTIVE,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        unselectedItemColor: ColorConstants.NORMAL,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _Item {
  String name;
  IconData icon;

  _Item(this.name, this.icon);
}
