import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/screens/poi_details/local_widgets/itinerary_action_bar.dart';
import 'package:mobile/screens/poi_details/local_widgets/itinerary_details.dart';
import 'package:mobile/screens/poi_details/local_widgets/itinerary_highlight.dart';
import 'package:mobile/screens/poi_details/local_widgets/itinerary_summary.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "套餐详情",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ScreenUtils.isMobilePlatform()
              ? Colors.transparent
              : ColorConstants.APP_BAR_DARK_TRANSPARENT,
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
                        isMyItinerary: isMyItinerary,
                      )
                    ],
                    padding: EdgeInsets.only(bottom: 100),
                  ),
                  Positioned(
                      bottom: 0,
                      width: ScreenUtils.screenWidth(context),
                      child: ItineraryActionBar(
                        itinerary: itinerary,
                        isPublic: itinerary.isPublic,
                        isMyItinerary: isMyItinerary,
                        onUpdateItinerary: (Itinerary updatedItinerary) {
                          setState(() {
                            itinerary = updatedItinerary;
                          });
                        },
                      ))
                ],
              ),
      );
    });
  }

  void getItineraryDetail() async {
    var data = await ApiService().getItineraryDetail(widget.itineraryId,
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
                  .currentAuth
                  .userId;
    });
  }

  void getDayTripsList() async {
    var data = await ApiService().getDayTrips(widget.itineraryId,
        Provider.of<AppState>(context, listen: false).getAccessToken());
    setState(() {
      dayTripsList = data;
    });
  }
}

class CommentWidget extends StatefulWidget {
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('lots of comments'));
  }
}
