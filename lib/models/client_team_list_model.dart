// To parse this JSON data, do
//
//     final clientTeamListModel = clientTeamListModelFromJson(jsonString);

import 'dart:convert';

ClientTeamListModel clientTeamListModelFromJson(String str) => ClientTeamListModel.fromJson(json.decode(str));

String clientTeamListModelToJson(ClientTeamListModel data) => json.encode(data.toJson());

class ClientTeamListModel {
    String message;
    String status;
    List<ClientTeamList> response;

    ClientTeamListModel({
        required this.message,
        required this.status,
        required this.response,
    });

    factory ClientTeamListModel.fromJson(Map<String, dynamic> json) => ClientTeamListModel(
        message: json["Message"],
        status: json["Status"],
        response: List<ClientTeamList>.from(json["Response"].map((x) => ClientTeamList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    };
}

class ClientTeamList {
    int mid;
    String team;

    ClientTeamList({
        required this.mid,
        required this.team,
    });

    factory ClientTeamList.fromJson(Map<String, dynamic> json) => ClientTeamList(
        mid: json["MID"],
        team: json["TEAM"],
    );

    Map<String, dynamic> toJson() => {
        "MID": mid,
        "TEAM": team,
    };
}
