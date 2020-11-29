import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:mobile/widgets/icons.dart';

class ItinerarySummaryWidget extends StatelessWidget {
  final Itinerary itinerary;

  const ItinerarySummaryWidget({Key key, this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        AspectRatio(
          aspectRatio: 6 / 5,
          child: ClipRRect(
              child: FittedBox(
            child: Image.network(
              itinerary.image,
            ),
            fit: BoxFit.cover,
          )),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            Text(
              itinerary.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text(
                itinerary.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
              ),
              width: ScreenUtils.screenWidth(context) * (2 / 3),
            ),
            Container(
              child: Row(
                children: [
                  SquareIcon(
                    color: ColorConstants.TEXT_PRIMARY,
                    width: 10,
                    margin: EdgeInsets.only(right: 10, top: 5),
                  ),
                  Expanded(
                    child: Text(
                      itinerary.cities.join(' / '),
                      style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              children: [],
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
        )
      ], crossAxisAlignment: CrossAxisAlignment.start),
      width: ScreenUtils.screenWidth(context),
    );
  }
}
