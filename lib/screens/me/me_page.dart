import 'package:flutter/material.dart';
import 'package:mobile/services/routing_service.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Column(children: [
        Container(
          child: Column(
            children: [
              Container(
                child: CircleAvatar(
                  radius: 50,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: appState.authService.currentUser == null ||
                            appState.authService.currentUser.picture == ''
                        ? AssetImage(
                            Constants.STATIC_IMG + 'default_user.png',
                          )
                        : NetworkImage(
                            appState.authService.currentUser.picture),
                  ),
                  backgroundColor: ColorConstants.BACKGROUND_LIGHT_BLUE,
                ),
                margin: EdgeInsets.only(top: 10, bottom: 20),
              ),
              getAuthComponent(appState)
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
                toPage: RoutingService.settingPage,
              ),
              OptionRow(
                icon: Icons.settings,
                text: '设置',
                toPage: RoutingService.settingPage,
                requireLogin: true,
              ),
            ],
          ),
          color: ColorConstants.BUTTON_WHITE,
          width: ScreenUtils.screenWidth(context),
          margin: EdgeInsets.symmetric(vertical: 5),
        ),
      ]);
    });
  }

  Widget getAuthComponent(AppState appState) {
    if (appState.authService.authStatus == AuthStatus.AUTHENTICATED &&
        appState.authService.currentUser != null) {
      return Text(appState.authService.currentUser.userName);
    } else {
      if (appState.authService.authStatus == AuthStatus.AUTHENTICATED) {
        appState.authService.getUser(forceGet: true);
      }
      return MaterialButton(
        child: Text(
          '点击登录',
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          RoutingService.pushNoParams(context, RoutingService.loginPage);
        },
      );
    }
  }
}

class OptionRow extends StatelessWidget {
  const OptionRow(
      {Key key,
      @required this.icon,
      @required this.text,
      this.toPage,
      this.requireLogin = false})
      : assert(icon != null),
        assert(text != null),
        super(key: key);

  final IconData icon;
  final String text;
  final String toPage;
  final bool requireLogin;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return InkWell(
        child: Container(
          child: Row(
            children: [
              Container(
                child: Icon(
                  icon,
                  color: ColorConstants.BUTTON_PRIMARY,
                ),
                margin: EdgeInsets.only(left: 10, right: 20),
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context,
                  color: ColorConstants.DIVIDER_PRIMARY),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
        onTap: () {
          if (requireLogin) {
            if (appState.authService.authStatus == AuthStatus.AUTHENTICATED) {
              RoutingService.pushNoParams(context, toPage);
            } else {
              RoutingService.pushNoParams(context, RoutingService.loginPage);
            }
          } else {
            RoutingService.pushNoParams(context, toPage);
          }
        },
      );
    });
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            InkWell(
              child: Container(
                child: Center(
                  child: Text('Logout'),
                ),
                color: ColorConstants.BUTTON_WHITE,
                width: ScreenUtils.screenWidth(context),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              ),
              onTap: () {
                appState.authService.logout();
                Navigator.pop(context);
              },
            )
          ],
        ),
        backgroundColor: ColorConstants.BACKGROUND_PRIMARY,
      );
    });
  }
}
