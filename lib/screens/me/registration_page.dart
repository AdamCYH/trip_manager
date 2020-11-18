import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isPasswordHidden = true;

  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('注册'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Builder(builder: (BuildContext context) {
            return Container(
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
                            child: Icon(
                              Icons.email,
                              color: ColorConstants.BUTTON_PRIMARY,
                            ),
                            margin: EdgeInsets.only(left: 10, right: 20),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: '请输入邮箱', border: InputBorder.none),
                              onChanged: (text) {
                                email = text;
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
                                obscureText: isPasswordHidden,
                                decoration: InputDecoration(
                                    hintText: '请输入密码',
                                    border: InputBorder.none),
                                onChanged: (text) {
                                  password = text;
                                }),
                          ),
                          Container(
                            child: IconButton(
                                icon: isPasswordHidden
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                color: ColorConstants.ICON_MEDIUM,
                                onPressed: () {
                                  setState(() {
                                    isPasswordHidden = !isPasswordHidden;
                                  });
                                }),
                          ),
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
                        '注册',
                        style: TextStyle(color: ColorConstants.TEXT_WHITE),
                      ),
                      onPressed: () {
                        if (validateInputs(context, appState)) {
                          try {
                            appState.createUser(User('', username, '', '',
                                email, password, false, '', ''));
                            Navigator.pop(context);
                          } catch (e) {
                            appState.notificationService
                                .showSnackBar(context, '暂时有些问题哦，请稍后再试。');
                          }
                        }
                      },
                      color: ColorConstants.BUTTON_PRIMARY,
                      minWidth: ScreenUtils.screenWidth(context) - 20,
                      height: 40,
                    ),
                    margin: EdgeInsets.all(5),
                  ),
                ],
              ),
            );
          }));
    });
  }

  bool validateInputs(BuildContext context, AppState appState) {
    if (username == '') {
      appState.notificationService.showSnackBar(context, '请输入用户名');
      return false;
    } else if (email == '') {
      appState.notificationService.showSnackBar(context, '请输入邮箱');
      return false;
    } else if (password == '') {
      appState.notificationService.showSnackBar(context, '请输入有效的密码');
      return false;
    }
    return true;
  }
}
