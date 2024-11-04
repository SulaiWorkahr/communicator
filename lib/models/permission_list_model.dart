// To parse this JSON data, do
//
//     final permissionListModel = permissionListModelFromJson(jsonString);

import 'dart:convert';

PermissionListModel permissionListModelFromJson(String str) => PermissionListModel.fromJson(json.decode(str));

String permissionListModelToJson(PermissionListModel data) => json.encode(data.toJson());

class PermissionListModel {
    String message;
    String status;
    List<PermissionListData> response;

    PermissionListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory PermissionListModel.fromJson(Map<String, dynamic> json) => PermissionListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<PermissionListData>.from(json["Response"].map((x) => PermissionListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class PermissionListData {
    int mid;
    String empName;
    String empDept;
    String empLocation;
    DateTime date;
    String permissionType;
    String? remark;
    DateTime time;
    DateTime preTime;
    DateTime postTime;
    String? preRemark1;
    String? postRemark2;
    String approvedBy;

    PermissionListData({
        required this.mid,
        required this.empName,
        required this.empDept,
        required this.empLocation,
        required this.date,
        required this.permissionType,
         this.remark,
        required this.time,
        required this.preTime,
        required this.postTime,
         this.preRemark1,
         this.postRemark2,
        required this.approvedBy,
    });

    factory PermissionListData.fromJson(Map<String, dynamic> json) => PermissionListData(
        mid: json["MID"],
        empName: json["EMP_NAME"],
        empDept: json["EMP_DEPT"],
        empLocation: json["EMP_LOCATION"],
        date: DateTime.parse(json["DATE"]),
        permissionType: json["PERMISSION_TYPE"],
        remark: json["REMARK"],
        time: DateTime.parse(json["TIME"]),
        preTime: DateTime.parse(json["PRE_TIME"]),
        postTime: DateTime.parse(json["POST_TIME"]),
        preRemark1: json["PRE_REMARK1"],
        postRemark2: json["POST_REMARK2"],
        approvedBy: json["APPROVED_BY"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "EMP_NAME": empName,
        "EMP_DEPT": empDept,
        "EMP_LOCATION": empLocation,
        "DATE": date.toIso8601String(),
        "PERMISSION_TYPE": permissionType,
        "REMARK": remark,
        "TIME": time.toIso8601String(),
        "PRE_TIME": preTime.toIso8601String(),
        "POST_TIME": postTime.toIso8601String(),
        "PRE_REMARK1": preRemark1,
        "POST_REMARK2": postRemark2,
        "APPROVED_BY": approvedBy,
    };
}

