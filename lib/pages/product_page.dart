import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/http/sample_data.dart';
import 'package:mobile/widgets/cards.dart';

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
        indicatorColor: ColorConstants.TEXT_SECONDARY,
        controller: _tabController,
        tabs: tabs,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [HotItineraryWidget(), PickedItineraryWidget()],
      ),
    );
  }
}

class HotItineraryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: SampleData.itinerariesSet1.values
          .map(
            (itinerary) =>
                ImageWithCenteredTextCardWidget(itinerary: itinerary),
          )
          .toList(),
    );
  }
}

class PickedItineraryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: SampleData.itinerariesSet1.values
          .map(
            (itinerary) =>
                ImageWithSeparateBottomTextCardWidget(itinerary: itinerary),
          )
          .toList(),
    );
  }
}
