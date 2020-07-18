class User {
  final String userId;
  final String firstName;
  final String lastName;
  final bool isStaff;
  final String accessToken;
  final String refreshToken;

  User(this.userId, this.firstName, this.lastName, this.isStaff,
      this.accessToken, this.refreshToken);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        isStaff = json['is_staff'],
        accessToken = json['access'],
        refreshToken = json['refresh'];

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'is_staff': isStaff,
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
