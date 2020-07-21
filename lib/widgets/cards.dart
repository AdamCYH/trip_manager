import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/pages/Itinerary_detail_page.dart';
import 'package:mobile/util/screen_utl.dart';

import '../Router.dart';

class SquareCardWidget extends StatelessWidget {
  const SquareCardWidget(
      {Key key, @required this.width, @required this.itinerary})
      : assert(width != null),
        super(key: key);

  final double width;
  final Itinerary itinerary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ClipRRect(
                child: FittedBox(
                  child: Image.network(
                    itinerary.image,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: width,
              height: width,
            ),
            Container(
              child: Text(itinerary.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Constants.PRIMARY_FONT_SIZE)),
              margin: EdgeInsets.only(top: 20, bottom: 10),
            ),
            Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: SquareIcon(
                          color: ColorConstants.TEXT_SECONDARY, width: 10),
                      margin: EdgeInsets.only(left: 3, top: 5, right: 5),
                    ),
                    Expanded(
                        child: Text(
                      itinerary.cities.join(' / '),
                      style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                width: width),
          ],
        ),
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 15),
      ),
      onTap: () {
        Router.push(context, Router.itineraryPage, itinerary.id);
      },
    );
  }
}

class ImageWithCenteredTextCardWidget extends StatelessWidget {
  const ImageWithCenteredTextCardWidget({Key key, @required this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  final ItinerarySample itinerary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          child: Stack(
            children: <Widget>[
              FittedBox(
                child: Image(
                    image: AssetImage(
                  Constants.STATIC_IMG + itinerary.imgName,
                )),
                fit: BoxFit.cover,
              ),
              Container(
                color: ColorConstants.OVERLAY,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      itinerary.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w100),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(boxShadow: kElevationToShadow[24]),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.all(3),
                    ),
                    Container(
                      child: Text(
                        itinerary.locations.join(' / '),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w100),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      constraints: BoxConstraints(maxWidth: 200),
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              )
            ],
            fit: StackFit.expand,
          ),
          height: 250,
          width: ScreenUtils.screenWidth(context)),
      onTap: () {
        Router.push(context, Router.itineraryPage, itinerary.name);
      },
    );
  }
}

class ImageWithSeparateBottomTextCardWidget extends StatelessWidget {
  const ImageWithSeparateBottomTextCardWidget(
      {Key key, @required this.itinerary})
      : assert(itinerary != null),
        super(key: key);

  final ItinerarySample itinerary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            Container(
              child: FittedBox(
                child: Image(
                        image: AssetImage(
                      Constants.STATIC_IMG + itinerary.imgName,
                    )),
                fit: BoxFit.cover,
              ),
              height: 230,
              width: ScreenUtils.screenWidth(context),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          itinerary.name,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.TEXT_PRIMARY),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              itinerary.country,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    margin: EdgeInsets.all(5),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            SquareIcon(
                                color: ColorConstants.TEXT_PRIMARY, width: 10),
                            Container(
                              child: Text(
                                itinerary.locations.join(' / '),
                                style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                            )
                          ],
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(5),
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            )
          ],
        ),
      ),
      onTap: () {
        Router.push(context, Router.itineraryPage, itinerary.name);
      },
    );
  }
}

class SquareIcon extends StatelessWidget {
  const SquareIcon({Key key, @required this.color, @required this.width})
      : assert(color != null),
        assert(width != null),
        super(key: key);

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(color: color),
    );
  }
}
