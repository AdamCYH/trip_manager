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
  final String name;
  final String country;
  final List<String> locations;
  final String description;
  final String imgName;
  final String author;

  const Itinerary(this.name, this.country, this.locations, this.description,
      this.imgName, this.author);
}
