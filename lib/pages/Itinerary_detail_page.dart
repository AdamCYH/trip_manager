import 'package:flutter/material.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/util/screen_utl.dart';

class ItineraryPage extends StatefulWidget {
  ItineraryPage(this.itineraryId, {Key key}) : super(key: key);

  final String itineraryId;

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  Itinerary itinerary;

  @override
  void initState() {
    super.initState();
    getItineraryDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "套餐详情",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 4,
        centerTitle: true,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: itinerary == null
          ? Container()
          : Container(
              child: FittedBox(
                child: Image.network(
                  itinerary.image,
                ),
                fit: BoxFit.cover,
              ),
              height: 350,
              width: ScreenUtils.screenWidth(context),
            ),
    );
  }

  void getItineraryDetail() async {
    var iti = await API().getItineraryDetail(widget.itineraryId);
    setState(() {
      itinerary = iti;
    });
  }
}
