import 'package:flutter/material.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/util/screen_utl.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var username;
    var password;
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('登录'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          child: Icon(
                            Icons.account_box,
                            color: ColorConstants.BUTTON_PRIMARY,
                          ),
                          margin: EdgeInsets.only(left: 10, right: 20),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: '请输入用户名', border: InputBorder.none),
                            onChanged: (text) {
                              username = text;
                            },
                          ),
                        )
                      ]),
                      Row(children: [
                        Container(
                          child: Icon(Icons.vpn_key,
                              color: ColorConstants.BUTTON_PRIMARY),
                          margin: EdgeInsets.only(left: 10, right: 20),
                        ),
                        Expanded(
                          child: TextField(
                              decoration: InputDecoration(
                                  hintText: '请输入密码', border: InputBorder.none),
                              onChanged: (text) {
                                password = text;
                              }),
                        )
                      ]),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  color: ColorConstants.BACKGROUND_WHITE,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                ),
                Container(
                  child: MaterialButton(
                    child: Text(
                      '登录',
                      style: TextStyle(color: ColorConstants.TEXT_WHITE),
                    ),
                    onPressed: () async {
                      authService.login(username: username, password: password);
                    },
                    color: ColorConstants.BUTTON_PRIMARY,
                    minWidth: ScreenUtils.screenWidth(context) - 20,
                    height: 40,
                  ),
                  margin: EdgeInsets.all(5),
                ),
                Container(
                  child: MaterialButton(
                    child: Text('取消'),
                    onPressed: () {
                      authService.isLoginPageHidden = true;
                    },
                    color: ColorConstants.BUTTON_WHITE,
                    minWidth: ScreenUtils.screenWidth(context) - 20,
                    height: 40,
                  ),
                  margin: EdgeInsets.all(5),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
