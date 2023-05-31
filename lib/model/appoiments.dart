import 'dart:convert';

List<ApoinmentList> apoinmentListFromJson(String str) =>
    List<ApoinmentList>.from(
        json.decode(str).map((x) => ApoinmentList.fromJson(x)));

String apoinmentListToJson(List<ApoinmentList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApoinmentList {
  ApoinmentList({
    required this.id,
    required this.serviceCategoryId,
    required this.customerId,
    required this.requestDate,
    required this.appointmentDateTime,
    required this.customerAddressId,
    required this.estimatedBudget,
    required this.jobType,
    required this.addtionalInfo,
    required this.jobStatus,
    required this.paymentStatus,
    this.selectedServiceProviderId,
    required this.createdAt,
    required this.updatedAt,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.customerAddress,
    required this.serviceCategory,
  });

  int id;
  int serviceCategoryId;
  int customerId;
  DateTime requestDate;
  DateTime appointmentDateTime;
  int customerAddressId;
  String estimatedBudget;
  String jobType;
  String addtionalInfo;
  String jobStatus;
  String paymentStatus;
  dynamic selectedServiceProviderId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime appointmentDate;
  String appointmentTime;
  CustomerAddress customerAddress;
  ServiceCategory serviceCategory;

  factory ApoinmentList.fromJson(Map<String, dynamic> json) => ApoinmentList(
        id: json["id"],
        serviceCategoryId: json["service_category_id"],
        customerId: json["customer_id"],
        requestDate: DateTime.parse(json["request_date"]),
        appointmentDateTime: DateTime.parse(json["appointment_date_time"]),
        customerAddressId: json["customer_address_id"],
        estimatedBudget: json["estimated_budget"],
        jobType: json["job_type"],
        addtionalInfo: json["addtional_info"],
        jobStatus: json["job_status"],
        paymentStatus: json["payment_status"],
        selectedServiceProviderId: json["selected_service_provider_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        appointmentDate: DateTime.parse(json["appointment_date"]),
        appointmentTime: json["appointment_time"],
        customerAddress: CustomerAddress.fromJson(json["customer_address"]),
        serviceCategory: ServiceCategory.fromJson(json["service_category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "customer_id": customerId,
        "request_date": requestDate.toIso8601String(),
        "appointment_date_time": appointmentDateTime.toIso8601String(),
        "customer_address_id": customerAddressId,
        "estimated_budget": estimatedBudget,
        "job_type": jobType,
        "addtional_info": addtionalInfo,
        "job_status": jobStatus,
        "payment_status": paymentStatus,
        "selected_service_provider_id": selectedServiceProviderId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "appointment_date":
            "${appointmentDate.year.toString().padLeft(4, '0')}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}",
        "appointment_time": appointmentTime,
        "customer_address": customerAddress.toJson(),
        "service_category": serviceCategory.toJson(),
      };
}

class CustomerAddress {
  CustomerAddress({
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
  String ing;
  String lat;
  int customerId;
  DateTime createdAt;
  DateTime updatedAt;

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        id: json["id"],
        addressType: json["address_type"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        ing: json["ing"],
        lat: json["lat"],
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

class ServiceCategory {
  ServiceCategory({
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

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
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
