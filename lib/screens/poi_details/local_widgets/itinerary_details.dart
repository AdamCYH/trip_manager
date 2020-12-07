import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/screens/poi_details/itinerary_detail_page.dart';
import 'package:mobile/screens/poi_details/local_widgets/day_trip_card.dart';

class ItineraryDetailsWidget extends StatefulWidget {
  final Itinerary itinerary;
  final List<DayTrip> dayTripsList;
  final bool isMyItinerary;

  const ItineraryDetailsWidget(
      {Key key, this.itinerary, this.dayTripsList, this.isMyItinerary = false})
      : assert(itinerary != null),
        super(key: key);

  @override
  _ItineraryDetailsWidgetState createState() => _ItineraryDetailsWidgetState();
}

class _ItineraryDetailsWidgetState extends State<ItineraryDetailsWidget>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  final List<Tab> tabs = <Tab>[
    Tab(
      text: '详情',
    ),
    Tab(
      text: '评价',
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_onItemTapped);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _onItemTapped() {
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TabBar(
            indicatorColor: ColorConstants.TEXT_PRIMARY,
            labelColor: ColorConstants.TEXT_PRIMARY,
            controller: _tabController,
            tabs: tabs,
          ),
          [
            widget.dayTripsList == null
                ? Container()
                : DayTripsListWidget(
                    dayTripsList: widget.dayTripsList,
                    isMyItinerary: widget.isMyItinerary,
                  ),
            CommentWidget(),
          ][_tabIndex],
        ],
      ),
    );
  }
}

class DayTripsListWidget extends StatelessWidget {
  final List<DayTrip> dayTripsList;
  final bool isMyItinerary;

  const DayTripsListWidget(
      {Key key, this.dayTripsList, this.isMyItinerary = false})
      : assert(dayTripsList != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dayTripsList
          .asMap()
          .entries
          .map(
            (entry) => DayTripCard(
              dayTrip: entry.value,
              dayNumber: entry.key + 1,
              totalDays: dayTripsList.length,
              isMyItinerary: isMyItinerary,
            ),
          )
          .toList(),
    );
  }
}
