import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/widgets/vertical_line.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/services/routing_service.dart';
import 'package:mobile/widgets/icons.dart';
import 'package:provider/provider.dart';

class DayTripCard extends StatelessWidget {
  // Day box height 30
  // Top padding 10
  // Icon radius 5
  static const double CIRCLE_ICON_OFFSET = 30 / 2 + 10 - 5;

  // Day box height 30
  // Day box vertical padding 20
  // Day trips vertical padding 20
  // Subtract icon offset
  // Some padding 10
  static const double DAY_TRIP_VERTICAL_WHITE_SPACE =
      70 - CIRCLE_ICON_OFFSET - 5 + 10;

  static const double LINE_HEIGHT = 24;

  // Line height 24
  // Padding 20
  static const double DAY_TRIP_HEIGHT = LINE_HEIGHT + 20;

  final DayTrip dayTrip;
  final int dayNumber;
  final int totalDays;

  final bool isMyItinerary;

  const DayTripCard(
      {Key key,
      this.dayTrip,
      this.dayNumber,
      this.totalDays,
      this.isMyItinerary = false})
      : assert(dayTrip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                    child: dayNumber == 1
                        ? Container(
                            height: CIRCLE_ICON_OFFSET,
                          )
                        : VerticalLine(
                            height: CIRCLE_ICON_OFFSET,
                            lineWidth: 0.5,
                          )),
                CircleIcon(color: ColorConstants.ICON_BRIGHTER, diameter: 10),
                Container(
                    child: dayNumber == totalDays && !isMyItinerary
                        ? Container()
                        : VerticalLine(
                            height: isMyItinerary
                                ? dayTripSitesHeight + LINE_HEIGHT
                                : dayTripSitesHeight,
                            lineWidth: 0.5,
                          )),
              ],
            ),
          ),
          Expanded(
              flex: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DayTagWidget(
                      widget: Text(
                    'D${dayTrip.day.toString()}',
                    style: TextStyle(color: ColorConstants.TEXT_WHITE),
                  )),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstants.BACKGROUND_LIGHT_BLUE),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                        children: isMyItinerary
                            ? (dayTripSiteRows(dayTrip, context)
                              ..add(addSiteRow(onTap: () {
                                Provider.of<AppState>(context, listen: false)
                                    .routingService
                                    .pushNoParams(
                                        context, RoutingService.poiSearchPage);
                              })))
                            : dayTripSiteRows(dayTrip, context)),
                  )
                ],
              ))
        ],
      ),
    );
  }

  List<InkWell> dayTripSiteRows(DayTrip dayTrip, BuildContext context) {
    return dayTrip.sites
        .map((dayTripSite) => InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        dayTripSite.site.getIcon(),
                        color: ColorConstants.ICON_MEDIUM,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${dayTripSite.site.getCategory()}:',
                        style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        dayTripSite.site.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Provider.of<AppState>(context, listen: false)
                    .routingService
                    .push(context, RoutingService.sitePage, dayTripSite.site);
              },
            ))
        .toList();
  }

  InkWell addSiteRow({Function() onTap}) => InkWell(
        child: InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topRight,
            child: Icon(Icons.add, color: ColorConstants.ICON_MEDIUM),
          ),
          onTap: onTap,
        ),
      );

  double get dayTripSitesHeight =>
      DAY_TRIP_VERTICAL_WHITE_SPACE + DAY_TRIP_HEIGHT * dayTrip.sites.length;
}

class DayTagWidget extends StatelessWidget {
  final Widget widget;

  const DayTagWidget({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: widget),
      decoration: BoxDecoration(
          color: ColorConstants.BUTTON_PRIMARY,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: 50,
      height: 30,
      margin: EdgeInsets.all(10),
    );
  }
}
