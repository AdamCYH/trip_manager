import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile/RoutingService.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:provider/provider.dart';

class MyItinerariesPage extends StatefulWidget {
  @override
  _MyItinerariesPageState createState() => _MyItinerariesPageState();
}

class _MyItinerariesPageState extends State<MyItinerariesPage> {
  @override
  void initState() {
    print('init itinerary page');
    if (Provider.of<AppState>(context, listen: false).authService.authStatus ==
        AuthStatus.AUTHENTICATED) {
      Provider.of<AppState>(context, listen: false).getMyItinerariesList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      if (appState.myItinerariesMap.isEmpty) {
        Provider.of<AppState>(context, listen: false).getMyItinerariesList();
      }
      if (appState.authService.authStatus == AuthStatus.AUTHENTICATED) {
        return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<AppState>(context, listen: false)
                  .getMyItinerariesList(forceGet: true);
            },
            child: Stack(
              children: [
                ListView(
                  children: appState.myItinerariesMap.entries
                      .map((entry) => Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            key:
                                ObjectKey(appState.myItinerariesMap[entry.key]),
                            child: ImageLeftTextRightWidget(
                                itinerary:
                                    appState.myItinerariesMap[entry.key]),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'More',
                                color: Colors.black45,
                                icon: Icons.more_horiz,
                                onTap: () => null,
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () => {
                                  appState.deleteItinerary(
                                      appState.myItinerariesMap[entry.key].id)
                                },
                              ),
                            ],
                          ))
                      .toList(),
                ),
                Positioned(
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      backgroundColor: ColorConstants.BACKGROUND_DARK_BLUE,
                      onPressed: () {
                        RoutingService.pushNoParams(
                            context, RoutingService.createItineraryPage);
                      },
                    ),
                    bottom: 30,
                    right: 30),
              ],
            ));
      } else {
        return Center(
          child: MaterialButton(
            child: Text(
              '点击登录',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              RoutingService.pushNoParams(context, RoutingService.loginPage);
            },
          ),
        );
      }
    });
  }
}
