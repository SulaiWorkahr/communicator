// To parse this JSON data, do
//
//     final workfromHomeListModel = workfromHomeListModelFromJson(jsonString);

import 'dart:convert';

WorkfromHomeListModel workfromHomeListModelFromJson(String str) => WorkfromHomeListModel.fromJson(json.decode(str));

String workfromHomeListModelToJson(WorkfromHomeListModel data) => json.encode(data.toJson());

class WorkfromHomeListModel {
    String message;
    String status;
    List<WorkfromHomeListData> response;

    WorkfromHomeListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory WorkfromHomeListModel.fromJson(Map<String, dynamic> json) => WorkfromHomeListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<WorkfromHomeListData>.from(json["Response"].map((x) => WorkfromHomeListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class WorkfromHomeListData {
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

    WorkfromHomeListData({
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

    factory WorkfromHomeListData.fromJson(Map<String, dynamic> json) => WorkfromHomeListData(
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


