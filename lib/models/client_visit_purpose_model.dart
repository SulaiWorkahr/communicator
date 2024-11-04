// To parse this JSON data, do
//
//     final clientVisitPurposeModel = clientVisitPurposeModelFromJson(jsonString);

import 'dart:convert';

ClientVisitPurposeModel clientVisitPurposeModelFromJson(String str) => ClientVisitPurposeModel.fromJson(json.decode(str));

String clientVisitPurposeModelToJson(ClientVisitPurposeModel data) => json.encode(data.toJson());

class ClientVisitPurposeModel {
    String message;
    String status;
    List<VisitPurposeList> response;

    ClientVisitPurposeModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory ClientVisitPurposeModel.fromJson(Map<String, dynamic> json) => ClientVisitPurposeModel(
        message: json["Message"],
        status: json["Status"],
        response: List<VisitPurposeList>.from(json["Response"].map((x) => VisitPurposeList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class VisitPurposeList {
    int mid;
    String team;
    String supportType;
    String description;

    VisitPurposeList({
        required this.mid,
        required this.team,
        required this.supportType,
        required this.description,
    });

    factory VisitPurposeList.fromJson(Map<String, dynamic> json) => VisitPurposeList(
        mid: json["MID"],
        team: json["TEAM"],
        supportType: json["SUPPORT_TYPE"],
        description: json["DESCRIPTION"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "TEAM": team,
        "SUPPORT_TYPE": supportType,
        "DESCRIPTION": description,
    };
}
