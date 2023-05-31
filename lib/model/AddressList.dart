import 'dart:convert';

List<AddressList> addressListFromJson(String str) => List<AddressList>.from(
    json.decode(str).map((x) => AddressList.fromJson(x)));

String addressListToJson(List<AddressList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressList {
  AddressList({
    required this.id,
    required this.addressType,
    required this.address1,
    required this.address2,
    required this.city,
    required this.ing,
    required this.lat,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String addressType;
  String address1;
  String address2;
  String city;
  double ing;
  double lat;
  int customerId;
  DateTime createdAt;
  DateTime updatedAt;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        addressType: json["address_type"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        ing: json["ing"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        customerId: json["customer_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_type": addressType,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "ing": ing,
        "lat": lat,
        "customer_id": customerId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
