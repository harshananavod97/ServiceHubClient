import 'dart:convert';

OneProviderDetails oneProviderDetailsFromJson(String str) =>
    OneProviderDetails.fromJson(json.decode(str));

String oneProviderDetailsToJson(OneProviderDetails data) =>
    json.encode(data.toJson());

class OneProviderDetails {
  OneProviderDetails({
    required this.id,
    required this.fullName,
    required this.email,
    this.emailVerifiedAt,
    required this.password,
    required this.nic,
    required this.address1,
    required this.address2,
    required this.city,
    required this.serviceCategoryId,
    this.profilePic,
    required this.description,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.jobRating,
  });

  int id;
  String fullName;
  String email;
  dynamic emailVerifiedAt;
  String password;
  String nic;
  String address1;
  String address2;
  String city;
  int serviceCategoryId;
  dynamic profilePic;
  String description;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;
  List<JobRating> jobRating;

  factory OneProviderDetails.fromJson(Map<String, dynamic> json) =>
      OneProviderDetails(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        password: json["password"],
        nic: json["nic"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        serviceCategoryId: json["service_category_id"],
        profilePic: json["profile_pic"],
        description: json["description"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        jobRating: List<JobRating>.from(
            json["jobRating"].map((x) => JobRating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "password": password,
        "nic": nic,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "service_category_id": serviceCategoryId,
        "profile_pic": profilePic,
        "description": description,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "jobRating": List<dynamic>.from(jobRating.map((x) => x.toJson())),
      };
}

class JobRating {
  JobRating({
    this.avgRating,
  });

  dynamic avgRating;

  factory JobRating.fromJson(Map<String, dynamic> json) => JobRating(
        avgRating: json["avg_rating"],
      );

  Map<String, dynamic> toJson() => {
        "avg_rating": avgRating,
      };
}
