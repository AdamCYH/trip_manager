import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class HotelsList extends StatefulWidget {
  @override
  _HotelsListState createState() => _HotelsListState();
}

class _HotelsListState extends State<HotelsList> {
  Future<List<Site>> attractions;

  @override
  void initState() {
    super.initState();
    attractions =
        Provider.of<AppState>(context, listen: false).listHotelSites();
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
                    .map((hotel) => ImageLeftTextRightWidget(
                          image: Image.network(hotel.photo),
                          title: hotel.name,
                          locations: [hotel.city.name],
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
