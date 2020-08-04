import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/util/screen_utl.dart';
import 'package:provider/provider.dart';

class CreateItineraryPage extends StatefulWidget {
  @override
  _CreateItineraryPageState createState() => _CreateItineraryPageState();
}

class _CreateItineraryPageState extends State<CreateItineraryPage> {
  File _image;
  String _title;
  String _description;
  final picker = ImagePicker();
  String base64Image;
  String errMessage = 'Error Uploading Image';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建行程'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          children: [
            Container(
              child: _image == null
                  ? MaterialButton(
                      onPressed: chooseImage,
                      child: Text('选择图片'),
                    )
                  : Stack(
                      children: [
                        FittedBox(
                          child: Container(
                            child: Image.file(_image),
                          ),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: ColorConstants.TEXT_RED,
                            ),
                            onPressed: () {
                              setState(() => _image = null);
                            },
                            padding: EdgeInsets.symmetric(vertical: 30),
                          ),
                          top: 0,
                          right: 0,
                        )
                      ],
                      fit: StackFit.expand,
                    ),
              width: ScreenUtils.screenWidth(context),
              height: 350,
              decoration: BoxDecoration(color: ColorConstants.BACKGROUND_WHITE),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            Container(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: '标题', border: InputBorder.none),
                    onChanged: (text) {
                      _title = text;
                    },
                  ),
                  Divider(),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '亮点 / 简介', border: InputBorder.none),
                    onChanged: (text) {
                      _description = text;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 10,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              color: ColorConstants.BACKGROUND_WHITE,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            ),
            FlatButton(
              child: Text('创建行程'),
              onPressed: () async {
                try {
                  await Provider.of<AppState>(context, listen: false)
                      .createItinerary(
                          {'title': _title, 'description': _description},
                          [_image.path]);
                  Navigator.pop(context);
                } catch (e) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Unable to create itinerary. Please try again later.")));
                }

                return;
              },
              color: ColorConstants.BUTTON_PRIMARY,
              textColor: ColorConstants.TEXT_WHITE,
              padding: EdgeInsets.all(15),
            )
          ],
        );
      }),
      backgroundColor: ColorConstants.BACKGROUND_PRIMARY,
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
