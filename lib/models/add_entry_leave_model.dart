// To parse this JSON data, do
//
//     final addEntryLeaveModel = addEntryLeaveModelFromJson(jsonString);

import 'dart:convert';

AddEntryLeaveModel addEntryLeaveModelFromJson(String str) => AddEntryLeaveModel.fromJson(json.decode(str));

String addEntryLeaveModelToJson(AddEntryLeaveModel data) => json.encode(data.toJson());

class AddEntryLeaveModel {
    String message;
    String status;
    LeaveResponse response;

    AddEntryLeaveModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory AddEntryLeaveModel.fromJson(Map<String, dynamic> json) => AddEntryLeaveModel(
        message: json["Message"],
        status: json["Status"],
        response: LeaveResponse.fromJson(json["Response"]),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": response.toJson(),
    };
}

class LeaveResponse {
    int mid;
    String empName;
    String empDept;
    String empLocation;
    String leaveType;
    DateTime leaveAppliedOn;
    String halfFullDay;
    String approvedBy;
    String remarks;
    DateTime startDate;
    DateTime endDate;
    int noOfDays;
    String approvalStatus;
    String rejectionRemarks;

    LeaveResponse({
        required this.mid,
        required this.empName,
        required this.empDept,
        required this.empLocation,
        required this.leaveType,
        required this.leaveAppliedOn,
        required this.halfFullDay,
        required this.approvedBy,
        required this.remarks,
        required this.startDate,
        required this.endDate,
        required this.noOfDays,
        required this.approvalStatus,
        required this.rejectionRemarks,
    });

    factory LeaveResponse.fromJson(Map<String, dynamic> json) => LeaveResponse(
        mid: json["MID"],
        empName: json["EMP_NAME"],
        empDept: json["EMP_DEPT"],
        empLocation: json["EMP_LOCATION"],
        leaveType: json["LEAVE_TYPE"],
        leaveAppliedOn: DateTime.parse(json["LEAVE_APPLIED_ON"]),
        halfFullDay: json["HALF_FULL_DAY"],
        approvedBy: json["APPROVED_BY"],
        remarks: json["REMARKS"],
        startDate: DateTime.parse(json["START_DATE"]),
        endDate: DateTime.parse(json["END_DATE"]),
        noOfDays: json["NO_OF_DAYS"],
        approvalStatus: json["APPROVAL_STATUS"],
        rejectionRemarks: json["REJECTION_REMARKS"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "EMP_NAME": empName,
        "EMP_DEPT": empDept,
        "EMP_LOCATION": empLocation,
        "LEAVE_TYPE": leaveType,
        "LEAVE_APPLIED_ON": leaveAppliedOn.toIso8601String(),
        "HALF_FULL_DAY": halfFullDay,
        "APPROVED_BY": approvedBy,
        "REMARKS": remarks,
        "START_DATE": startDate.toIso8601String(),
        "END_DATE": endDate.toIso8601String(),
        "NO_OF_DAYS": noOfDays,
        "APPROVAL_STATUS": approvalStatus,
        "REJECTION_REMARKS": rejectionRemarks,
    };
}
