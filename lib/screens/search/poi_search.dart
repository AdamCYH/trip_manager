import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/screens/search/activity_list.dart';
import 'package:mobile/screens/search/hotel_list.dart';
import 'package:mobile/screens/search/restaurant_list.dart';
import 'package:mobile/widgets/app_scaffold.dart';

class PoiSearchPage extends StatefulWidget {
  @override
  _PoiSearchPageState createState() => _PoiSearchPageState();
}

class _PoiSearchPageState extends State<PoiSearchPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(
      text: '活动',
    ),
    Tab(
      text: '酒店',
    ),
    Tab(
      text: '餐厅',
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldDefault(
      title: "添加地点",
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
          indicatorColor: ColorConstants.TEXT_BRIGHT_GREEN_BLUE,
          controller: _tabController,
          tabs: tabs,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [AttractionsList(), HotelsList(), RestaurantsList()],
        ),
      ),
    );
  }
}
