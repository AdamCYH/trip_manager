import 'package:flutter/material.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/utils/provider_utils.dart';
import 'package:mobile/widgets/general_cards.dart';
import 'package:provider/provider.dart';

class AttractionsList extends StatefulWidget {
  final List<Site> attractionCache;
  final Function(List<Site>) onUpdate;

  const AttractionsList({Key key, this.attractionCache, this.onUpdate})
      : assert(onUpdate != null),
        super(key: key);

  @override
  _AttractionsListState createState() => _AttractionsListState();
}

class _AttractionsListState extends State<AttractionsList> {
  Future<List<Site>> attractions;

  @override
  void initState() {
    super.initState();
    if (this.widget.attractionCache != null) {
      attractions = Future.value(this.widget.attractionCache);
    } else {
      attractions = ServiceProvider.apiService(context)
          .listAttractions(AuthProvider.accessToken(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List<Site>>(
          future: attractions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                this.widget.onUpdate(snapshot.data);
              });
              return attractionsList(snapshot.data);
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<AppState>(context, listen: false)
                    .notificationService
                    .showSnackBar(context, "暂时无法获取活动列表哦，请稍后再试！");
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

  Widget attractionsList(List<Site> attractions) {
    return ListView(
      children: attractions
          .map((attraction) => ImageLeftTextRightWidget(
                image: Image.network(attraction.photo),
                title: attraction.name,
                locations: [attraction.city.name],
              ))
          .toList(),
    );
  }
}
