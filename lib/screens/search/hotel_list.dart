import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class HotelsList extends StatefulWidget {
  final List<Site> hotelsCache;
  final Function(List<Site>) onUpdate;

  const HotelsList({Key key, this.hotelsCache, this.onUpdate})
      : assert(onUpdate != null),
        super(key: key);

  @override
  _HotelsListState createState() => _HotelsListState();
}

class _HotelsListState extends State<HotelsList> {
  Future<List<Site>> hotels;

  @override
  void initState() {
    super.initState();

    if (this.widget.hotelsCache != null) {
      hotels = Future.value(this.widget.hotelsCache);
    } else {
      hotels = Provider.of<AppState>(context, listen: false).listHotelSites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List<Site>>(
          future: hotels,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                this.widget.onUpdate(snapshot.data);
              });
              return hotelsList(snapshot.data);
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<AppState>(context, listen: false)
                    .notificationService
                    .showSnackBar(context, "暂时无法获取酒店列表哦，请稍后再试！");
              });
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget hotelsList(List<Site> hotels) {
    return ListView(
      children: hotels
          .map((hotel) => ImageLeftTextRightWidget(
                image: Image.network(hotel.photo),
                title: hotel.name,
                locations: [hotel.city.name],
              ))
          .toList(),
    );
  }
}
