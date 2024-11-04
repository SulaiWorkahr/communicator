// To parse this JSON data, do
//
//     final supportCustomerModel = supportCustomerModelFromJson(jsonString);

import 'dart:convert';

SupportCustomerModel supportCustomerModelFromJson(String str) => SupportCustomerModel.fromJson(json.decode(str));

String supportCustomerModelToJson(SupportCustomerModel data) => json.encode(data.toJson());

class SupportCustomerModel {
    String status;
    String message;
    List<SupportCustomer> supportCustomers;

    SupportCustomerModel({
        required this.status,
        required this.message,
        required this.supportCustomers,
    });

    // Update the key to match the JSON response
    factory SupportCustomerModel.fromJson(Map<String, dynamic> json) => SupportCustomerModel(
        status: json["status"],
        message: json["message"],
        supportCustomers: List<SupportCustomer>.from(json["SupportCustomers"].map((x) => SupportCustomer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "SupportCustomers": List<dynamic>.from(supportCustomers.map((x) => x.toJson())),  // Use the same key here
    };
}

class SupportCustomer {
    String accode;
    String accountHead;
    String? accountHeads;

    SupportCustomer({
        required this.accode,
        required this.accountHead,
        this.accountHeads
    });

    factory SupportCustomer.fromJson(Map<String, dynamic> json) => SupportCustomer(
        accode: json["ACCODE"],
        accountHead: json["ACCOUNT_HEAD"],
        accountHeads: json["ACCOUNT_HEADS"]
    );

    Map<String, dynamic> toJson() => {
        "ACCODE": accode,
        "ACCOUNT_HEAD": accountHead,
        "ACCOUNT_HEADS": accountHeads
    };
}


// import 'dart:convert';

// SupportCustomerModel supportCustomerModelFromJson(String str) => SupportCustomerModel.fromJson(json.decode(str));

// String supportCustomerModelToJson(SupportCustomerModel data) => json.encode(data.toJson());

// class SupportCustomerModel {
//     String? status;
//     String? message;
//     List<SupportCustomer>? supportCustomers;

//     SupportCustomerModel({
//         this.status,
//         this.message,
//         this.supportCustomers,
//     });

//     factory SupportCustomerModel.fromJson(Map<String, dynamic> json) => SupportCustomerModel(
//         status: json["status"] ?? '',
//         message: json["message"] ?? '',
//         supportCustomers: json["supportCustomers"] == null
//             ? []
//             : List<SupportCustomer>.from(json["supportCustomers"].map((x) => SupportCustomer.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status ?? '',
//         "message": message ?? '',
//         "supportCustomers": supportCustomers == null
//             ? []
//             : List<dynamic>.from(supportCustomers!.map((x) => x.toJson())),
//     };
// }

// class SupportCustomer {
//     String? accode;
//     String? accountHead;

//     SupportCustomer({
//         this.accode,
//         this.accountHead,
//     });

//     factory SupportCustomer.fromJson(Map<String, dynamic> json) => SupportCustomer(
//         accode: json["ACCODE"] ?? '',
//         accountHead: json["ACCOUNT_HEAD"] ?? '',
//     );

//     Map<String, dynamic> toJson() => {
//         "ACCODE": accode ?? '',
//         "ACCOUNT_HEAD": accountHead ?? '',
//     };
// }
