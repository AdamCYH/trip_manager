import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';

class AppScaffoldDefault extends StatelessWidget {
  final title;
  final List<Widget> actions;
  final Widget body;

  AppScaffoldDefault({
    Key key,
    this.actions,
    this.body,
    this.title,
  })  : assert(title != null),
        assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        elevation: 0,
        centerTitle: true,
        actions: actions,
      ),
      body: body,
      backgroundColor: ColorConstants.BACKGROUND_PRIMARY,
    );
  }
}
