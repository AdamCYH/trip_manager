import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/services/routing_service.dart';
import 'package:provider/provider.dart';

class ItineraryActionBar extends StatelessWidget {
  final isPublic;
  final isMyItinerary;
  final Itinerary itinerary;
  final Function(Itinerary) onUpdateItinerary;

  ItineraryActionBar(
      {this.itinerary,
      this.isPublic = false,
      this.isMyItinerary = false,
      this.onUpdateItinerary})
      : assert(itinerary != null);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Container(
        child: Row(
          children: [
            isMyItinerary
                ? InkWell(
                    child: Container(
                      child: Center(
                          child: Icon(
                        isPublic ? Icons.public : Icons.public_off,
                        color: ColorConstants.BUTTON_WHITE,
                      )),
                      color: isPublic
                          ? ColorConstants.TEXT_BRIGHT_GREEN_BLUE
                          : ColorConstants.ICON_MEDIUM,
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () async {
                      var updatedItinerary = await appState.editItinerary(
                          itineraryId: itinerary.id,
                          fields: (itinerary..isPublic = !itinerary.isPublic)
                              .toJson(),
                          filePaths: []);
                      if (updatedItinerary != null) {
                        onUpdateItinerary(updatedItinerary);
                      }
                    },
                  )
                : Container(),
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
                appState.routingService
                    .push(context, RoutingService.loginPage, {});
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
                    onTap: () async {
                      final updatedItinerary = appState.routingService.push(
                          context, RoutingService.editItineraryPage, itinerary);
                      if (updatedItinerary != null) {
                        onUpdateItinerary(updatedItinerary);
                      }
                    },
                  )
                : Container()
          ],
        ),
        height: 50,
      );
    });
  }
}
