import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

class ImageLeftTextRightWidget extends StatelessWidget {
  final Image image;
  final List<String> locations;
  final String title;
  final Function() onTap;

  const ImageLeftTextRightWidget(
      {Key key,
      @required this.image,
      @required this.title,
      this.locations,
      this.onTap})
      : assert(image != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          child: Row(
            children: [
              Container(
                child: ClipRRect(
                  child: FittedBox(
                    child: image,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 150,
                height: 150,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 17),
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: ColorConstants.TEXT_PRIMARY,
                                  size: 14,
                                ),
                                margin: EdgeInsets.all(2),
                              ),
                              Expanded(
                                  child: Text(
                                locations.join('  |  '),
                                style: TextStyle(
                                    color: ColorConstants.TEXT_SECONDARY,
                                    fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                        children: [Text(''), Text('')],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ))
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          color: ColorConstants.BACKGROUND_WHITE,
          padding: EdgeInsets.all(10),
          height: 170,
        ),
        onTap: onTap);
  }
}
