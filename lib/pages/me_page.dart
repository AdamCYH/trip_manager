import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/util/screen_utl.dart';
import 'package:provider/provider.dart';

import 'package:mobile/models/auth_service.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      print('build me page');
      if (authService.tokensAvailable) {
        return Container(
            child: Column(
          children: [
            Text('logged in'),
            MaterialButton(
              child: Text('Logout'),
              onPressed: () {
                authService.logout();
                setState(() {
                  authService.isLoginPageHidden = true;
                });
              },
            )
          ],
        ));
      } else {
        return Column(children: [
          Container(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  child: CircleAvatar(
                    radius: 53,
                    backgroundImage: AssetImage(
                      Constants.STATIC_IMG + 'default_user.png',
                    ),
                  ),
                  backgroundColor: ColorConstants.BACKGROUND_LIGHT_BLUE,
                ),
                MaterialButton(
                  child: Text('点击登录', style: TextStyle(fontSize: 16),),
                  onPressed: () {
                    setState(() {
                      authService.isLoginPageHidden = false;
                    });
                  },
                )
              ],
            ),
            color: ColorConstants.BUTTON_WHITE,
            width: ScreenUtils.screenWidth(context),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 5),
          ),
          Container(
            child: Column(
              children: [
                OptionRow(
                  icon: Icons.bookmark_border,
                  text: '我的收藏',
                ),
                OptionRow(
                  icon: Icons.settings,
                  text: '设置',
                )
              ],
            ),
            color: ColorConstants.BUTTON_WHITE,
            width: ScreenUtils.screenWidth(context),
            margin: EdgeInsets.symmetric(vertical: 5),
          ),
        ]);
      }
    });
  }
}

class OptionRow extends StatelessWidget {
  const OptionRow({Key key, @required this.icon, @required this.text})
      : assert(icon != null),
        assert(text != null),
        super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Icon(
              icon,
              color: ColorConstants.BUTTON_PRIMARY,
            ),
            margin: EdgeInsets.only(left: 10, right: 20),
          ),
          Text(text, style: TextStyle(fontSize: 16),)
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context,
              color: ColorConstants.DIVIDER_PRIMARY),
        ),
      ),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 20),
    );
  }
}
