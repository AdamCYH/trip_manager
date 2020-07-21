import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:provider/provider.dart';

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
        children: [HotItineraryWidget(), FeaturedItineraryWidget()],
      ),
    );
  }
}

class HotItineraryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Featured>>(
        future: Provider.of<AppState>(context, listen: false).getFeaturedList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Featured>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data
                  .map((featured) => ImageWithCenteredTextCardWidget(
                      itinerary: featured.itinerary))
                  .toList(),
            );
          } else {
            return Container();
          }
        });
  }
}

class FeaturedItineraryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Itinerary>>(
        future: Provider.of<AppState>(context, listen: false).getHotList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Itinerary>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data
                  .map((itinerary) => ImageWithSeparateBottomTextCardWidget(
                      itinerary: itinerary))
                  .toList(),
            );
          } else {
            return Container();
          }
        });
  }
}
