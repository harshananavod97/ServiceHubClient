// To parse this JSON data, do
//
//     final jobProvider = jobProviderFromJson(jsonString);

import 'dart:convert';

JobProvider jobProviderFromJson(String str) =>
    JobProvider.fromJson(json.decode(str));

String jobProviderToJson(JobProvider data) => json.encode(data.toJson());

class JobProvider {
  JobProvider({
    required this.id,
    required this.jobId,
    required this.serviceProviderId,
    required this.estimatedTime,
    required this.estimatedBudget,
    required this.comment,
    required this.approval,
    required this.createdAt,
    required this.updatedAt,
    required this.job,
    required this.serviceProvider,
  });

  int id;
  int jobId;
  int serviceProviderId;
  String estimatedTime;
  String estimatedBudget;
  String comment;
  String approval;
  DateTime createdAt;
  DateTime updatedAt;
  Job job;
  ServiceProvider serviceProvider;

  factory JobProvider.fromJson(Map<String, dynamic> json) => JobProvider(
        id: json["id"] ?? "",
        jobId: json["job_id"] ?? "",
        serviceProviderId: json["service_provider_id"] ?? "",
        estimatedTime: json["estimated_time"] ?? "",
        estimatedBudget: json["estimated_budget"] ?? "",
        comment: json["comment"] ?? "",
        approval: json["approval"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? ""),
        updatedAt: DateTime.parse(json["updated_at"] ?? ""),
        job: Job.fromJson(json["job"] ?? ""),
        serviceProvider:
            ServiceProvider.fromJson(json["service_provider"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "service_provider_id": serviceProviderId,
        "estimated_time": estimatedTime,
        "estimated_budget": estimatedBudget,
        "comment": comment,
        "approval": approval,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "job": job.toJson(),
        "service_provider": serviceProvider.toJson(),
      };
}

class Job {
  Job({
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
  CustomerAddress customerAddress;
  ServiceCategory serviceCategory;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"] ?? "",
        serviceCategoryId: json["service_category_id"] ?? "",
        customerId: json["customer_id"] ?? "",
        requestDate: DateTime.parse(json["request_date"] ?? ""),
        appointmentDateTime:
            DateTime.parse(json["appointment_date_time"] ?? ""),
        customerAddressId: json["customer_address_id"] ?? "",
        estimatedBudget: json["estimated_budget"] ?? "",
        jobType: json["job_type"] ?? "",
        addtionalInfo: json["addtional_info"] ?? "",
        jobStatus: json["job_status"] ?? "",
        paymentStatus: json["payment_status"] ?? "",
        selectedServiceProviderId: json["selected_service_provider_id"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? ""),
        updatedAt: DateTime.parse(json["updated_at"] ?? ""),
        customerAddress:
            CustomerAddress.fromJson(json["customer_address"] ?? ""),
        serviceCategory:
            ServiceCategory.fromJson(json["service_category"] ?? ""),
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
        id: json["id"] ?? "",
        addressType: json["address_type"] ?? "",
        address1: json["address_1"] ?? "",
        address2: json["address_2"] ?? "",
        city: json["city"] ?? "",
        ing: json["ing"] ?? "",
        lat: json["lat"] ?? "",
        customerId: json["customer_id"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? ""),
        updatedAt: DateTime.parse(json["updated_at"] ?? ""),
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
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        payoutRate: json["payout_rate"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? ""),
        updatedAt: DateTime.parse(json["updated_at"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "payout_rate": payoutRate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ServiceProvider {
  ServiceProvider({
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
    this.description,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNumber,
    required this.avgRating,
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
  dynamic description;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;
  String phoneNumber;
  int avgRating;

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      ServiceProvider(
        id: json["id"] ?? "",
        fullName: json["full_name"] ?? "",
        email: json["email"] ?? "",
        emailVerifiedAt: json["email_verified_at"] ?? "",
        password: json["password"] ?? "",
        nic: json["nic"] ?? "",
        address1: json["address_1"] ?? "",
        address2: json["address_2"] ?? "",
        city: json["city"] ?? "",
        serviceCategoryId: json["service_category_id"] ?? "",
        profilePic: json["profile_pic"] ?? "",
        description: json["description"] ?? "",
        rememberToken: json["remember_token"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? ""),
        updatedAt: DateTime.parse(json["updated_at"] ?? ""),
        phoneNumber: json["phone_number"] ?? "",
        avgRating: json["avg_rating"] ?? "",
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
        "phone_number": phoneNumber,
        "avg_rating": avgRating,
      };
}
