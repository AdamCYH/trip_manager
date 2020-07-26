import 'package:flutter/material.dart';
import 'package:mobile/Router.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:provider/provider.dart';

class MyItineraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      if (appState.authService.authStatus == AuthStatus.AUTHENTICATED) {
        return FutureBuilder<List<Itinerary>>(
            future: appState.getMyItinerariesList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Itinerary>> snapshot) {
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
      } else {
        Router.push(context, Router.loginPage, {});
        return null;
      }
    });
  }
}
