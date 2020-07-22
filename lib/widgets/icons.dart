import 'package:flutter/material.dart';

class SquareIcon extends StatelessWidget {
  const SquareIcon(
      {Key key, @required this.color, @required this.width, this.margin})
      : assert(color != null),
        assert(width != null),
        super(key: key);

  final Color color;
  final double width;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(color: color),
      margin: margin,
    );
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon(
      {Key key, @required this.color, @required this.diameter, this.margin})
      : assert(color != null),
        assert(diameter != null),
        super(key: key);

  final Color color;
  final double diameter;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      margin: margin,
    );
  }
}
