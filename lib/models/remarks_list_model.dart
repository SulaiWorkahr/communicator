// To parse this JSON data, do
//
//     final remarksListModel = remarksListModelFromJson(jsonString);

import 'dart:convert';

RemarksListModel remarksListModelFromJson(String str) => RemarksListModel.fromJson(json.decode(str));

String remarksListModelToJson(RemarksListModel data) => json.encode(data.toJson());

class RemarksListModel {
    String message;
    String status;
    List<RemarksList> response;

    RemarksListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory RemarksListModel.fromJson(Map<String, dynamic> json) => RemarksListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<RemarksList>.from(json["Response"].map((x) => RemarksList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class RemarksList {
    int mid;
    String remarks;

    RemarksList({
        required this.mid,
        required this.remarks,
    });

    factory RemarksList.fromJson(Map<String, dynamic> json) => RemarksList(
        mid: json["MID"],
        remarks: json["REMARKS"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "REMARKS": remarks,
    };
}
