import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

/// Centered vertical line widget used to indicate day trips.
class VerticalLine extends StatelessWidget {
  final double height;
  final double lineWidth;

  VerticalLine({this.height, this.lineWidth})
      : assert(height != null),
        assert(lineWidth != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: ColorConstants.ICON_BRIGHTER,
                            width: lineWidth))),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: ColorConstants.ICON_BRIGHTER,
                              width: lineWidth))),
                ))
          ],
        ));
  }
}
