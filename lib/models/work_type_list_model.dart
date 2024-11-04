// To parse this JSON data, do
//
//     final workTypeListModel = workTypeListModelFromJson(jsonString);

import 'dart:convert';

WorkTypeListModel workTypeListModelFromJson(String str) => WorkTypeListModel.fromJson(json.decode(str));

String workTypeListModelToJson(WorkTypeListModel data) => json.encode(data.toJson());

class WorkTypeListModel {
    String message;
    String status;
    List<WorkTypeListData> response;

    WorkTypeListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory WorkTypeListModel.fromJson(Map<String, dynamic> json) => WorkTypeListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<WorkTypeListData>.from(json["Response"].map((x) => WorkTypeListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class WorkTypeListData {
    int mid;
    String type;

    WorkTypeListData({
        required this.mid,
        required this.type,
    });

    factory WorkTypeListData.fromJson(Map<String, dynamic> json) => WorkTypeListData(
        mid: json["MID"],
        type: json["TYPE"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "TYPE": type,
    };
}
