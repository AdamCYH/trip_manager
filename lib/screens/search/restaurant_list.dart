import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/utils/provider_utils.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class RestaurantsList extends StatefulWidget {
  final List<Site> restaurantCache;
  final Function(List<Site>) onUpdate;

  const RestaurantsList({Key key, this.restaurantCache, this.onUpdate})
      : assert(onUpdate != null),
        super(key: key);

  @override
  _RestaurantsListState createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  Future<List<Site>> restaurants;

  @override
  void initState() {
    super.initState();

    if (this.widget.restaurantCache != null) {
      restaurants = Future.value(this.widget.restaurantCache);
    } else {
      restaurants = ServiceProvider.apiService(context)
          .listRestaurants(AuthProvider.accessToken(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List<Site>>(
          future: restaurants,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                this.widget.onUpdate(snapshot.data);
              });
              return restaurantsList(snapshot.data);
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<AppState>(context, listen: false)
                    .notificationService
                    .showSnackBar(context, "暂时无法获取餐厅列表哦，请稍后再试！");
              });
              print("${snapshot.error}");
              return Container();
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget restaurantsList(List<Site> restaurants) {
    return ListView(
      children: restaurants
          .map((restaurant) => ImageLeftTextRightWidget(
                image: Image.network(restaurant.photo),
                title: restaurant.name,
                locations: [restaurant.city.name],
              ))
          .toList(),
    );
  }
}
