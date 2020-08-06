import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/Itinerary_detail_page.dart';
import 'package:mobile/pages/create_itinerary_page.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/me_page.dart';
import 'package:mobile/pages/product_page.dart';
import 'package:mobile/pages/registration_page.dart';
import 'package:mobile/pages/site_detail_page.dart';

///https://www.jianshu.com/p/b9d6ec92926f

class Router {
  static const homePage = 'app://';
  static const productsPage = 'app://products';
  static const itineraryPage = 'app://itinerary';
  static const sitePage = 'app://site';
  static const loginPage = 'app://login';
  static const settingPage = 'app://setting';
  static const createItineraryPage = 'app://createItinerary';
  static const registrationPage = 'app://registration';

  Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return Container();
    } else {
      switch (url) {
        case createItineraryPage:
          return CreateItineraryPage();
        case homePage:
          return HomePage();
        case itineraryPage:
          return ItineraryPage(params);
        case loginPage:
          return LoginPage();
        case productsPage:
          return ProductsPage();
        case registrationPage:
          return RegistrationPage();
        case settingPage:
          return SettingPage();
        case sitePage:
          return SiteDetailPage(params);
      }
    }
    return null;
  }

  Router.pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }

  Router.push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}
