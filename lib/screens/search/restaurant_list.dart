import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class RestaurantsList extends StatefulWidget {
  @override
  _RestaurantsListState createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  Future<List<Site>> attractions;

  @override
  void initState() {
    super.initState();
    attractions =
        Provider.of<AppState>(context, listen: false).listRestaurantSites();
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
                    .map((restaurant) => ImageLeftTextRightWidget(
                  image: Image.network(restaurant.photo),
                  title: restaurant.name,
                  locations: [restaurant.city.name],
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
