import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/itinerary_details/Itinerary_detail_page.dart';
import 'package:mobile/screens/create/create_itinerary_page.dart';
import 'package:mobile/screens/create/edit_itinerary_page.dart';
import 'package:mobile/screens/home/home_page.dart';
import 'package:mobile/screens/me/login_page.dart';
import 'package:mobile/screens/me/me_page.dart';
import 'package:mobile/screens/community/product_page.dart';
import 'package:mobile/screens/me/registration_page.dart';
import 'package:mobile/screens/itinerary_details/site_detail_page.dart';

class RoutingService {
  static const homePage = 'app://';
  static const productsPage = 'app://products';
  static const itineraryPage = 'app://itinerary';
  static const sitePage = 'app://site';
  static const loginPage = 'app://login';
  static const settingPage = 'app://setting';
  static const createItineraryPage = 'app://createItinerary';
  static const editItineraryPage = 'app://editItinerary';
  static const registrationPage = 'app://registration';

  Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return Container();
    } else {
      switch (url) {
        case createItineraryPage:
          return CreateItineraryPage();
        case editItineraryPage:
          return EditItineraryPage(params);
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

  RoutingService();

//  RoutingService.pushNoParams(BuildContext context, String url) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return _getPage(url, null);
//    }));
//  }
//
//  RoutingService.push(BuildContext context, String url, dynamic params) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return _getPage(url, params);
//    }));
//  }

  push(BuildContext context, String url, dynamic params) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }

  pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }
}
