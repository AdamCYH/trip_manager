import 'package:mobile/http/API.dart';

class Auth {
  final String userId;
  final String accessToken;
  final String refreshToken;

  Auth(this.userId, this.accessToken, this.refreshToken);

  Auth.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        accessToken = json['access'],
        refreshToken = json['refresh'];
}

class User {
  final String userId;
  String firstName;
  String lastName;
  bool isStaff;
  String picture;
  String alias;

  User(this.userId, this.firstName, this.lastName, this.isStaff);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        isStaff = json['is_staff'],
        picture = API.BASE_URL + json['profile_pic'],
        alias = json['first_name'] + ' ' + json['last_name'];

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'profile_pic': picture,
        'alias': alias,
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
  final String owner;
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
      this.owner,
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
        owner = json['owner'],
        cities = json['locations'];
}

class Featured {
  final String id;
  final Itinerary itinerary;

  Featured(this.id, this.itinerary);

  Featured.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        itinerary = Itinerary.fromJson(json['itinerary']);
}

class ItinerarySample {
  final String name;
  final String country;
  final List<String> locations;
  final String description;
  final String imgName;
  final String author;

  const ItinerarySample(this.name, this.country, this.locations,
      this.description, this.imgName, this.author);
}
