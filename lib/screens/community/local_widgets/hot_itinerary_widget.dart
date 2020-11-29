import 'package:flutter/material.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:provider/provider.dart';

class HotItineraryWidget extends StatefulWidget {
  @override
  _HotItineraryWidgetState createState() => _HotItineraryWidgetState();
}

class _HotItineraryWidgetState extends State<HotItineraryWidget> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getHotList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return appState.hotItinerariesMap != null
          ? RefreshIndicator(
              onRefresh: () async {
                await Provider.of<AppState>(context, listen: false)
                    .getHotList(forceGet: true);
              },
              child: ListView(
                children: appState.hotItinerariesMap.entries
                    .map((entry) => ImageWithSeparateBottomTextCardWidget(
                        itinerary: entry.value))
                    .toList(),
              ))
          : Container();
    });
  }
}
