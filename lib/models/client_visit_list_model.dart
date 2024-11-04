// To parse this JSON data, do
//
//     final clientVisitListModel = clientVisitListModelFromJson(jsonString);

import 'dart:convert';

ClientVisitListModel clientVisitListModelFromJson(String str) => ClientVisitListModel.fromJson(json.decode(str));

String clientVisitListModelToJson(ClientVisitListModel data) => json.encode(data.toJson());

class ClientVisitListModel {
    String message;
    String status;
    List<ClientVisitListData> response;

    ClientVisitListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory ClientVisitListModel.fromJson(Map<String, dynamic> json) => ClientVisitListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<ClientVisitListData>.from(json["Response"].map((x) => ClientVisitListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class ClientVisitListData {
    int mid;
    String empName;
    String empDept;
    String approvedBy;
    String empLocation;
    String clientName;
    String clientLocation;
    String clientPoc;
    DateTime date;
    String visitPurpose;
    DateTime startTime;
    DateTime endTime;
    String team;

    ClientVisitListData({
        required this.mid,
        required this.empName,
        required this.empDept,
        required this.approvedBy,
        required this.empLocation,
        required this.clientName,
        required this.clientLocation,
        required this.clientPoc,
        required this.date,
        required this.visitPurpose,
        required this.startTime,
        required this.endTime,
        required this.team,
    });

    factory ClientVisitListData.fromJson(Map<String, dynamic> json) => ClientVisitListData(
        mid: json["MID"],
        empName: json["EMP_NAME"],
        empDept: json["EMP_DEPT"],
        approvedBy: json["APPROVED_BY"],
        empLocation: json["EMP_LOCATION"],
        clientName: json["CLIENT_NAME"],
        clientLocation: json["CLIENT_LOCATION"],
        clientPoc: json["CLIENT_POC"],
        date: DateTime.parse(json["DATE"]),
        visitPurpose: json["VISIT_PURPOSE"],
        startTime: DateTime.parse(json["START_TIME"]),
        endTime: DateTime.parse(json["END_TIME"]),
        team: json["TEAM"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "EMP_NAME": empName,
        "EMP_DEPT": empDept,
        "APPROVED_BY": approvedBy,
        "EMP_LOCATION": empLocation,
        "CLIENT_NAME": clientName,
        "CLIENT_LOCATION": clientLocation,
        "CLIENT_POC": clientPoc,
        "DATE": date.toIso8601String(),
        "VISIT_PURPOSE": visitPurpose,
        "START_TIME": startTime.toIso8601String(),
        "END_TIME": endTime.toIso8601String(),
        "TEAM": team,
    };
}