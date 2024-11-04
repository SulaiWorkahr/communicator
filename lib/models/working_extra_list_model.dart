// To parse this JSON data, do
//
//     final workingExtraListModel = workingExtraListModelFromJson(jsonString);

import 'dart:convert';

WorkingExtraListModel workingExtraListModelFromJson(String str) => WorkingExtraListModel.fromJson(json.decode(str));

String workingExtraListModelToJson(WorkingExtraListModel data) => json.encode(data.toJson());

class WorkingExtraListModel {
    String message;
    String status;
    List<WorkingExtraListData> response;

    WorkingExtraListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory WorkingExtraListModel.fromJson(Map<String, dynamic> json) => WorkingExtraListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<WorkingExtraListData>.from(json["Response"].map((x) => WorkingExtraListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class WorkingExtraListData {
    int mid;
    String empName;
    String empDept;
    String empLocation;
    String approvedBy;
    DateTime workedOn;
    String remarks;
    String workingDuring;
    String halfFullDay;
    String compensation;
    String workingLocation;
    String typeOfWork;
    DateTime checkInTime;
    DateTime checkOutTime;
    String? leaveTakenDates;
    int leaveOnMid;

    WorkingExtraListData({
        required this.mid,
        required this.empName,
        required this.empDept,
        required this.empLocation,
        required this.approvedBy,
        required this.workedOn,
        required this.remarks,
        required this.workingDuring,
        required this.halfFullDay,
        required this.compensation,
        required this.workingLocation,
        required this.typeOfWork,
        required this.checkInTime,
        required this.checkOutTime,
         this.leaveTakenDates,
        required this.leaveOnMid,
    });

    factory WorkingExtraListData.fromJson(Map<String, dynamic> json) => WorkingExtraListData(
        mid: json["MID"],
        empName: json["EMP_NAME"],
        empDept: json["EMP_DEPT"],
        empLocation: json["EMP_LOCATION"],
        approvedBy: json["APPROVED_BY"],
        workedOn: DateTime.parse(json["WORKED_ON"]),
        remarks: json["REMARKS"],
        workingDuring: json["WORKING_DURING"],
        halfFullDay: json["HALF_FULL_DAY"],
        compensation: json["COMPENSATION"],
        workingLocation: json["WORKING_LOCATION"],
        typeOfWork: json["TYPE_OF_WORK"],
        checkInTime: DateTime.parse(json["CHECK_IN_TIME"]),
        checkOutTime: DateTime.parse(json["CHECK_OUT_TIME"]),
        leaveTakenDates: json["LEAVE_TAKEN_DATES"],
        leaveOnMid: json["LEAVE_ON_MID"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "EMP_NAME": empName,
        "EMP_DEPT": empDept,
        "EMP_LOCATION": empLocation,
        "APPROVED_BY": approvedBy,
        "WORKED_ON": workedOn.toIso8601String(),
        "REMARKS": remarks,
        "WORKING_DURING": workingDuring,
        "HALF_FULL_DAY": halfFullDay,
        "COMPENSATION": compensation,
        "WORKING_LOCATION": workingLocation,
        "TYPE_OF_WORK": typeOfWork,
        "CHECK_IN_TIME": checkInTime.toIso8601String(),
        "CHECK_OUT_TIME": checkOutTime.toIso8601String(),
        "LEAVE_TAKEN_DATES": leaveTakenDates,
        "LEAVE_ON_MID": leaveOnMid,
    };
}
