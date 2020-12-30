import 'package:flutter/material.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/itinerary_cards.dart';
import 'package:provider/provider.dart';

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
