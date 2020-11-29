import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/screens/community/local_widgets/featured_itinerary_widget.dart';
import 'package:mobile/screens/community/local_widgets/hot_itinerary_widget.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(
      text: '精选行程',
    ),
    Tab(
      text: '热门行程',
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TabBar(
        indicatorColor: ColorConstants.TEXT_BRIGHT_GREEN_BLUE,
        controller: _tabController,
        tabs: tabs,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [FeaturedItineraryWidget(), HotItineraryWidget()],
      ),
    );
  }
}
