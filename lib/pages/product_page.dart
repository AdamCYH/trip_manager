import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/app_state.dart';
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

class HotItineraryWidget extends StatefulWidget {
  @override
  _HotItineraryWidgetState createState() => _HotItineraryWidgetState();
}

class _HotItineraryWidgetState extends State<HotItineraryWidget> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getHotList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return appState.hotItinerariesMap != null
          ? RefreshIndicator(
              onRefresh: () async {
                await Provider.of<AppState>(context, listen: false)
                    .getHotList(forceGet: true);
              },
              child: ListView(
                children: appState.hotItinerariesMap.entries
                    .map((entry) => ImageWithSeparateBottomTextCardWidget(
                        itinerary: entry.value))
                    .toList(),
              ))
          : Container();
    });
  }
}

class FeaturedItineraryWidget extends StatefulWidget {
  @override
  _FeaturedItineraryWidgetState createState() =>
      _FeaturedItineraryWidgetState();
}

class _FeaturedItineraryWidgetState extends State<FeaturedItineraryWidget> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getFeaturedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return appState.featuredItinerariesMap != null
          ? RefreshIndicator(
              onRefresh: () async {
                await Provider.of<AppState>(context, listen: false)
                    .getFeaturedList(forceGet: true);
              },
              child: ListView(
                children: appState.featuredItinerariesMap.entries
                    .map((entry) => ImageWithCenteredTextCardWidget(
                        itinerary: entry.value.itinerary))
                    .toList(),
              ))
          : Container();
    });
  }
}
