import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/utils/screen_utils.dart';

class ItineraryHighlightWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryHighlightWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '行程亮点',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '世界那么大，我想去看看',
            style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
          ),
          Container(
            child: Text(
              itinerary.description,
              textAlign: TextAlign.justify,
            ),
            margin: EdgeInsets.all(10),
          )
        ],
      ),
      width: ScreenUtils.screenWidth(context),
      margin: EdgeInsets.symmetric(vertical: 30),
    );
  }
}
