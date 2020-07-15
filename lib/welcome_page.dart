
import 'package:flutter/material.dart';

import 'app_structure.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var appStructure = AppStructure();

  bool isWelcomePageShown = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          child: appStructure,
          offstage: isWelcomePageShown,
        ),
        Offstage(
          child: Container(
            child: Stack(
              children: <Widget>[
                IconButton(icon: Icon(Icons.close), onPressed: _closePage,),
                Center(child: Text('Welcome to Triphub')),
              ],
            ),
          ),
          offstage: !isWelcomePageShown,
        )
      ],
    );
  }

  void _closePage() => setState(() => isWelcomePageShown = false);
}
