import 'package:flutter/material.dart';
import 'package:mobile/Router.dart';
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
        return appState.myItinerariesList != null
            ? RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<AppState>(context, listen: false)
                      .getMyItinerariesList(forceGet: true);
                },
                child: Stack(
                  children: [
                    ListView(
                      children: appState.myItinerariesList
                          .map((itinerary) =>
                              ImageLeftTextRightWidget(itinerary: itinerary))
                          .toList(),
                    ),
                    Positioned(
                        child: FloatingActionButton(
                          child: Icon(Icons.add),
                          backgroundColor: ColorConstants.BACKGROUND_DARK_BLUE,
                          onPressed: null,
                        ),
                        bottom: 30,
                        right: 30),
                  ],
                ))
            : Container();
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
