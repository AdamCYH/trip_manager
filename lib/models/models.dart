import 'package:flutter/material.dart';
import 'package:mobile/services/api_service.dart';

enum SiteCategory { Restaurant, Attraction, Hotel }

class Auth {
  final String userId;
  String accessToken;
  String refreshToken;

  Auth(this.userId, this.accessToken, this.refreshToken);

  Auth.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        accessToken = json['access'],
        refreshToken = json['refresh'];
}

class User {
  String userId;
  String userName;
  String firstName;
  String lastName;
  String email;
  String password;
  bool isStaff;
  String picture;
  String nickName;

  User(this.userId, this.userName, this.firstName, this.lastName, this.email,
      this.password, this.isStaff, this.picture, this.nickName);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        userName = json['username'],
        email = json['email'],
        isStaff = json['is_staff'],
        picture = ApiService.BASE_URL + (json['profile_pic'] ?? '/media/default.jpeg'),
        nickName = (json['first_name'] ?? '') + ' ' + (json['last_name'] ?? '');

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'username': userName,
        'email': email,
        'profile_pic': picture,
        'nick_name': nickName,
        'password': password,
      };
}

class Itinerary {
  final String id;
  final String image;
  final bool isLiked;
  final String title;
  final DateTime postedOn;
  final int view;
  final bool isPublic;
  final String description;
  final int like;
  final String ownerId;
  final List<dynamic> cities;

  Itinerary(
      this.id,
      this.image,
      this.isLiked,
      this.title,
      this.postedOn,
      this.view,
      this.isPublic,
      this.description,
      this.like,
      this.ownerId,
      this.cities);

  Itinerary.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        image = json['image'],
        isLiked = json['is_liked'],
        title = json['title'],
        postedOn = DateTime.parse(json['posted_on']),
        view = json['view'],
        isPublic = json['is_public'],
        description = json['description'],
        like = json['like'],
        ownerId = json['owner'],
        cities = json['locations'];
}

class DayTrip {
  final String id;
  final int day;
  final String ownerId;
  final String itineraryId;
  final List<DayTripSite> sites;

  DayTrip(this.id, this.day, this.ownerId, this.itineraryId, this.sites);

  DayTrip.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        day = json['day'],
        ownerId = json['owner'],
        itineraryId = json['itinerary'].toString(),
        sites = json['sites']
            .map<DayTripSite>((site) => DayTripSite.fromJson(site))
            .toList();
}

class DayTripSite {
  final String id;
  final String dayTripId;
  final Site site;
  final int order;

  DayTripSite(this.id, this.dayTripId, this.site, this.order);

  DayTripSite.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        dayTripId = json['day_trip'].toString(),
        site = Site.fromJson(json['site']),
        order = json['order'];
}

class Site {
  final String id;
  final City city;
  final String name;
  final SiteCategory siteCategory;
  final String url;
  final String address;
  final String description;
  final String photo;

  Site(this.id, this.city, this.name, this.siteCategory, this.url, this.address,
      this.description, this.photo);

  Site.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        city = City.fromJson(json['city']),
        name = json['name'],
        siteCategory = SiteCategory.values.firstWhere((category) {
          var categoryValue = 'SiteCategory.${json['site_category']}';
          return category.toString() == categoryValue;
        }),
        url = json['url'],
        address = json['address'],
        description = json['description'],
        photo = ApiService.BASE_URL + (json['photo'] ?? '/media/default.jpeg');

  getCategory() {
    switch (siteCategory) {
      case SiteCategory.Restaurant:
        return "餐厅";
        break;
      case SiteCategory.Attraction:
        return "活动";
        break;
      case SiteCategory.Hotel:
        return "住宿";
        break;
    }
  }

  getIcon() {
    switch (siteCategory) {
      case SiteCategory.Restaurant:
        return Icons.restaurant;
        break;
      case SiteCategory.Attraction:
        return Icons.flag;
        break;
      case SiteCategory.Hotel:
        return Icons.hotel;
        break;
    }
  }
}

class City {
  final String id;
  final String photo;
  final String country;
  final String name;

  City(this.id, this.photo, this.country, this.name);

  City.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        photo = json['photo'],
        country = json['country_name'],
        name = json['city_name'];
}

class Featured {
  final String id;
  final Itinerary itinerary;

  Featured(this.id, this.itinerary);

  Featured.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        itinerary = Itinerary.fromJson(json['itinerary']);
}

class Comment {
  final String id;
  final String content;
  final DateTime postedOn;
  final String itineraryId;
  final String ownerId;

  Comment(this.id, this.content, this.postedOn, this.itineraryId, this.ownerId);

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        content = json['comment'],
        postedOn = json['posted_on'],
        itineraryId = json['itinerary'],
        ownerId = json['owner'];
}
