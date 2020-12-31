import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class AttractionsList extends StatefulWidget {
  @override
  _AttractionsListState createState() => _AttractionsListState();
}

class _AttractionsListState extends State<AttractionsList> {
  Future<List<Site>> attractions;

  @override
  void initState() {
    super.initState();
    attractions =
        Provider.of<AppState>(context, listen: false).listAttractionSites();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List<Site>>(
          future: attractions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data
                    .map((attraction) => ImageLeftTextRightWidget(
                          image: Image.network(attraction.photo),
                          title: attraction.name,
                          locations: [attraction.city.name],
                        ))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
