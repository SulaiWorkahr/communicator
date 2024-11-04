// To parse this JSON data, do
//
//     final leaveApprovalListModel = leaveApprovalListModelFromJson(jsonString);

import 'dart:convert';

LeaveApprovalListModel leaveApprovalListModelFromJson(String str) => LeaveApprovalListModel.fromJson(json.decode(str));

String leaveApprovalListModelToJson(LeaveApprovalListModel data) => json.encode(data.toJson());

class LeaveApprovalListModel {
    String message;
    String status;
    List<LeaveApprovalData> response;

    LeaveApprovalListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory LeaveApprovalListModel.fromJson(Map<String, dynamic> json) => LeaveApprovalListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<LeaveApprovalData>.from(json["Response"].map((x) => LeaveApprovalData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class LeaveApprovalData {
    int mid;
    String? empName;
    String? empDept;
    String? empLocation;
    String? leaveType;
    DateTime leaveAppliedOn;
    String? halfFullDay;
    String? approvedBy;
    String? remarks;
    DateTime startDate;
    DateTime endDate;
    double noOfDays;
    String? approvalStatus;
    String? rejectionRemarks;

    LeaveApprovalData({
        required this.mid,
         this.empName,
         this.empDept,
         this.empLocation,
         this.leaveType,
        required this.leaveAppliedOn,
         this.halfFullDay,
         this.approvedBy,
         this.remarks,
        required this.startDate,
        required this.endDate,
        required this.noOfDays,
         this.approvalStatus,
         this.rejectionRemarks,
    });

    factory LeaveApprovalData.fromJson(Map<String, dynamic> json) => LeaveApprovalData(
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
        noOfDays: json["NO_OF_DAYS"]?.toDouble(),
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


