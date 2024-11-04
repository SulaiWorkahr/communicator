// To parse this JSON data, do
//
//     final addEntryModel = addEntryModelFromJson(jsonString);

import 'dart:convert';

AddEntryModel addEntryModelFromJson(String str) => AddEntryModel.fromJson(json.decode(str));

String addEntryModelToJson(AddEntryModel data) => json.encode(data.toJson());

class AddEntryModel {
    String message;
    String status;
    EntryResponse response;

    AddEntryModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory AddEntryModel.fromJson(Map<String, dynamic> json) => AddEntryModel(
        message: json["Message"],
        status: json["Status"],
        response: EntryResponse.fromJson(json["Response"]),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": response.toJson(),
    };
}

class EntryResponse {
    int mid;
    String empName;
    String empLocation;
    String empDept;
    DateTime workedOn;
    String approvedBy;
    String reason;
    String workingDuring;
    DateTime checkInTime;
    DateTime checkOutTime;
    String halfFullDay;

    EntryResponse({
        required this.mid,
        required this.empName,
        required this.empLocation,
        required this.empDept,
        required this.workedOn,
        required this.approvedBy,
        required this.reason,
        required this.workingDuring,
        required this.checkInTime,
        required this.checkOutTime,
        required this.halfFullDay,
    });

    factory EntryResponse.fromJson(Map<String, dynamic> json) => EntryResponse(
        mid: json["MID"],
        empName: json["EMP_NAME"],
        empLocation: json["EMP_LOCATION"],
        empDept: json["EMP_DEPT"],
        workedOn: DateTime.parse(json["WORKED_ON"]),
        approvedBy: json["APPROVED_BY"],
        reason: json["REASON"],
        workingDuring: json["WORKING_DURING"],
        checkInTime: DateTime.parse(json["CHECK_IN_TIME"]),
        checkOutTime: DateTime.parse(json["CHECK_OUT_TIME"]),
        halfFullDay: json["HALF_FULL_DAY"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "EMP_NAME": empName,
        "EMP_LOCATION": empLocation,
        "EMP_DEPT": empDept,
        "WORKED_ON": workedOn.toIso8601String(),
        "APPROVED_BY": approvedBy,
        "REASON": reason,
        "WORKING_DURING": workingDuring,
        "CHECK_IN_TIME": checkInTime.toIso8601String(),
        "CHECK_OUT_TIME": checkOutTime.toIso8601String(),
        "HALF_FULL_DAY": halfFullDay,
    };
}
