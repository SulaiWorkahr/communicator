// To parse this JSON data, do
//
//     final workfromHomeDeleteModel = workfromHomeDeleteModelFromJson(jsonString);

import 'dart:convert';

WorkfromHomeDeleteModel workfromHomeDeleteModelFromJson(String str) => WorkfromHomeDeleteModel.fromJson(json.decode(str));

String workfromHomeDeleteModelToJson(WorkfromHomeDeleteModel data) => json.encode(data.toJson());

class WorkfromHomeDeleteModel {
    String message;
    String status;
    dynamic response;

    WorkfromHomeDeleteModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory WorkfromHomeDeleteModel.fromJson(Map<String, dynamic> json) => WorkfromHomeDeleteModel(
        message: json["Message"],
        status: json["Status"],
        response: json["Response"],
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": response,
    };
}
