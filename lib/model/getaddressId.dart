// ignore: file_names
import 'dart:convert';

GetAdressId getAdressIdFromJson(String str) =>
    GetAdressId.fromJson(json.decode(str));

String getAdressIdToJson(GetAdressId data) => json.encode(data.toJson());

class GetAdressId {
  GetAdressId({
    required this.addressId,
  });

  int addressId;

  factory GetAdressId.fromJson(Map<String, dynamic> json) => GetAdressId(
        addressId: json["Address ID"],
      );

  Map<String, dynamic> toJson() => {
        "Address ID": addressId,
      };
}
