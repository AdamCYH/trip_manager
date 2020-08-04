import 'package:flutter/material.dart';
import 'package:mobile/Router.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyItinerariesPage extends StatefulWidget {
  @override
  _MyItinerariesPageState createState() => _MyItinerariesPageState();
}

class _MyItinerariesPageState extends State<MyItinerariesPage> {
  @override
  void initState() {
    if (Provider.of<AppState>(context, listen: false).authService.authStatus ==
        AuthStatus.AUTHENTICATED) {
      Provider.of<AppState>(context, listen: false).getMyItinerariesList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      if (appState.authService.authStatus == AuthStatus.AUTHENTICATED) {
        return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<AppState>(context, listen: false)
                  .getMyItinerariesList(forceGet: true);
            },
            child: Stack(
              children: [
                ListView.builder(
                    itemCount: appState.myItinerariesList == null
                        ? 0
                        : appState.myItinerariesList.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        key: ObjectKey(appState.myItinerariesList[index].id),
                        child: ImageLeftTextRightWidget(
                            itinerary: appState.myItinerariesList[index]),
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
                                  index, appState.myItinerariesList[index].id)
                            },
                          ),
                        ],
                      );
                    }),
                Positioned(
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      backgroundColor: ColorConstants.BACKGROUND_DARK_BLUE,
                      onPressed: () {
                        Router.push(context, Router.createItineraryPage, {});
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
              Router.push(context, Router.loginPage, {});
            },
          ),
        );
      }
    });
  }
}
