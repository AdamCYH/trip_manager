import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key key, @required this.title, @required this.size})
      : assert(title != null),
        assert(size != null),
        super(key: key);

  final String title;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 3,
            height: size,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: ColorConstants.PRIMARY),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size,
                color: ColorConstants.PRIMARY),
          )
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 20),
    );
  }
}
