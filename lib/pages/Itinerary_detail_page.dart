import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/http/sample_data.dart';
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
    print(widget.itineraryId);
    itinerary = SampleData.itinerariesSet1[widget.itineraryId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("套餐详情", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 8,
        centerTitle: true,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: FittedBox(
          child: Image(
              image: AssetImage(
            Constants.STATIC_IMG + itinerary.imgName,
          )),
          fit: BoxFit.cover,
        ),
        height: 350,
        width: ScreenUtils.screenWidth(context),
      ),
    );
  }
}
