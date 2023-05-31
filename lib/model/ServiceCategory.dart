// To parse this JSON data, do
//
//     final sericeNames = sericeNamesFromJson(jsonString);

import 'dart:convert';

SericeNames sericeNamesFromJson(String str) =>
    SericeNames.fromJson(json.decode(str));

String sericeNamesToJson(SericeNames data) => json.encode(data.toJson());

class SericeNames {
  SericeNames({
    required this.currentPage,
    required this.data,
    // required this.firstPageUrl,
    // required this.from,
    // required this.lastPage,
    // required this.lastPageUrl,
    // required this.links,
    // required this.path,
    // required this.perPage,
    // this.prevPageUrl,
    // required this.total,
  });

  int currentPage;
  List<Datum> data;
  // String firstPageUrl;
  // int from;
  // int lastPage;
  // String lastPageUrl;
  // List<Link> links;
  // String path;
  // int perPage;
  // dynamic prevPageUrl;
  // int total;

  factory SericeNames.fromJson(Map<String, dynamic> json) => SericeNames(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        // firstPageUrl: json["first_page_url"],
        // from: json["from"],
        // lastPage: json["last_page"],
        // lastPageUrl: json["last_page_url"],
        // links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        // path: json["path"],
        // perPage: json["per_page"],
        // prevPageUrl: json["prev_page_url"],
        // total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        // "first_page_url": firstPageUrl,
        // "from": from,
        // "last_page": lastPage,
        // "last_page_url": lastPageUrl,
        // "links": List<dynamic>.from(links.map((x) => x.toJson())),
        // "path": path,
        // "per_page": perPage,
        // "prev_page_url": prevPageUrl,
        // "total": total,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.payoutRate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String payoutRate;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        payoutRate: json["payout_rate"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "payout_rate": payoutRate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Link {
  Link({
    this.url,
    required this.label,
    required this.active,
  });

  String? url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? "",
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
