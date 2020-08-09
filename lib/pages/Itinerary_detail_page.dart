import 'package:flutter/material.dart';
import 'package:mobile/Router.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/util/screen_utl.dart';
import 'package:mobile/widgets/icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItineraryPage extends StatefulWidget {
  ItineraryPage(this.itineraryId, {Key key}) : super(key: key);

  final String itineraryId;

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  Itinerary itinerary;
  List<DayTrip> dayTripsList;
  bool isMyItinerary;

  @override
  void initState() {
    super.initState();
    getItineraryDetail();
    getDayTripsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "套餐详情",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 4,
        centerTitle: true,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Container(
            child: Icon(Icons.favorite_border),
            margin: EdgeInsets.symmetric(horizontal: 10),
          ),
          Container(
            child: SvgPicture.asset(Constants.STATIC_ICON + 'thumb_up.svg',
                color: Colors.white, semanticsLabel: 'thumb up'),
            margin: EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
      body: itinerary == null
          ? Container()
          : Stack(
              children: [
                ListView(
                  children: [
                    ItinerarySummaryWidget(
                      itinerary: itinerary,
                    ),
                    Divider(
                      thickness: 5,
                      color: ColorConstants.BACKGROUND_PRIMARY,
                    ),
                    ItineraryHighlightWidget(
                      itinerary: itinerary,
                    ),
                    Divider(
                      thickness: 5,
                      color: ColorConstants.BACKGROUND_PRIMARY,
                    ),
                    ItineraryDetailsWidget(
                      itinerary: itinerary,
                      dayTripsList: dayTripsList,
                    )
                  ],
                  padding: EdgeInsets.only(bottom: 100),
                ),
                Positioned(
                  bottom: 0,
                  width: ScreenUtils.screenWidth(context),
                  child: Container(
                      child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        child: Container(
                          child: Center(
                              child: Text(
                            '开始行程',
                            style: TextStyle(color: ColorConstants.TEXT_WHITE),
                          )),
                          color: ColorConstants.BUTTON_PRIMARY,
                          padding: EdgeInsets.all(15),
                        ),
                        onTap: () {
                          Router.push(context, Router.loginPage, {});
                        },
                      )),
                      isMyItinerary
                          ? InkWell(
                              child: Container(
                                child: Center(
                                    child: Icon(
                                  Icons.edit,
                                  color: ColorConstants.BUTTON_WHITE,
                                )),
                                color: ColorConstants.TEXT_BRIGHT_GREEN_BLUE,
                                padding: EdgeInsets.all(15),
                              ),
                              onTap: () {
                                Router.push(context, Router.editItineraryPage, itinerary);
                              },
                            )
                          : Container()
                    ],
                  ),
                  height: 50,),
                )
              ],
            ),
    );
  }

  void getItineraryDetail() async {
    var data = await API().getItineraryDetail(widget.itineraryId,
        Provider.of<AppState>(context, listen: false).getAccessToken());

    setState(() {
      itinerary = data;

      // Check if the itinerary belongs to current user.
      isMyItinerary = Provider.of<AppState>(context, listen: false)
                  .authService
                  .authStatus ==
              AuthStatus.AUTHENTICATED &&
          itinerary.ownerId ==
              Provider.of<AppState>(context, listen: false)
                  .authService
                  .currentUser
                  .userId;
    });
  }

  void getDayTripsList() async {
    var data = await API().getDayTrips(widget.itineraryId);
    setState(() {
      dayTripsList = data;
    });
  }
}

class ItinerarySummaryWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItinerarySummaryWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        Container(
          child: FittedBox(
            child: Image.network(
              itinerary.image,
            ),
            fit: BoxFit.cover,
          ),
          height: 350,
          width: ScreenUtils.screenWidth(context),
          margin: EdgeInsets.only(bottom: 20),
        ),
        Container(
          child: Column(children: [
            Text(
              itinerary.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text(
                itinerary.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
              ),
              width: ScreenUtils.screenWidth(context) * (2 / 3),
            ),
            Container(
              child: Row(
                children: [
                  SquareIcon(
                    color: ColorConstants.TEXT_PRIMARY,
                    width: 10,
                    margin: EdgeInsets.only(right: 10, top: 5),
                  ),
                  Expanded(
                    child: Text(
                      itinerary.cities.join(' / '),
                      style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              children: [],
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
          padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ], crossAxisAlignment: CrossAxisAlignment.start),
      width: ScreenUtils.screenWidth(context),
    );
  }
}

class ItineraryHighlightWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryHighlightWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '行程亮点',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '世界那么大，我想去看看',
            style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
          ),
          Container(
            child: Text(
              itinerary.description,
              textAlign: TextAlign.justify,
            ),
            margin: EdgeInsets.all(10),
          )
        ],
      ),
      width: ScreenUtils.screenWidth(context),
      margin: EdgeInsets.symmetric(vertical: 30),
    );
  }
}

class ItineraryDetailsWidget extends StatefulWidget {
  final Itinerary itinerary;
  final List<DayTrip> dayTripsList;

  const ItineraryDetailsWidget({Key key, this.itinerary, this.dayTripsList})
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
                  ),
            ItineraryCommentWidget(),
          ][_tabIndex],
        ],
      ),
    );
  }
}

class DayTripsListWidget extends StatelessWidget {
  final List<DayTrip> dayTripsList;

  const DayTripsListWidget({Key key, this.dayTripsList})
      : assert(dayTripsList != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dayTripsList.map((dayTrip) {
        return DayTripCard(
          dayTrip: dayTrip,
        );
      }).toList(),
    );
  }
}

class DayTripCard extends StatelessWidget {
  final DayTrip dayTrip;

  const DayTripCard({Key key, this.dayTrip})
      : assert(dayTrip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              child: Row(children: [
            CircleIcon(color: ColorConstants.ICON_BRIGHTER, diameter: 10),
            Container(
              child: Center(
                  child: Text(
                'D${dayTrip.day.toString()}',
                style: TextStyle(color: ColorConstants.TEXT_WHITE),
              )),
              decoration: BoxDecoration(
                  color: ColorConstants.BUTTON_PRIMARY,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: 50,
              height: 30,
              margin: EdgeInsets.all(10),
            )
          ])),
          Container(
            child: Column(
              children: dayTrip.sites
                  .map((dayTripSite) => InkWell(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: Icon(
                                  dayTripSite.site.getIcon(),
                                  color: ColorConstants.ICON_MEDIUM,
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${dayTripSite.site.getCategory()}:',
                                  style: TextStyle(
                                      color: ColorConstants.TEXT_SECONDARY),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10),
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
                          margin: EdgeInsets.all(10),
                        ),
                        onTap: () {
                          Router.push(
                              context, Router.sitePage, dayTripSite.site);
                        },
                      ))
                  .toList(),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: ColorConstants.BACKGROUND_LIGHT_BLUE),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(10),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: EdgeInsets.all(10),
    );
  }
}

class ItineraryCommentWidget extends StatefulWidget {
  @override
  _ItineraryCommentWidgetState createState() => _ItineraryCommentWidgetState();
}

class _ItineraryCommentWidgetState extends State<ItineraryCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('lots of comments'));
  }
}
