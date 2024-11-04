import 'dart:convert';

HolidayListModel holidayListModelFromJson(String str) => HolidayListModel.fromJson(json.decode(str));

String holidayListModelToJson(HolidayListModel data) => json.encode(data.toJson());

class HolidayListModel {
  String message;
  String status;
  List<HolidayListData> response;

  HolidayListModel({
    required this.message,
    required this.status,
    required this.response,
  });

  factory HolidayListModel.fromJson(Map<String, dynamic> json) => HolidayListModel(
    message: json["Message"] ?? '',
    status: json["Status"] ?? '',
    response: json["Response"] == null
        ? []
        : List<HolidayListData>.from(json["Response"].map((x) => HolidayListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "Response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class HolidayListData {
  int mid;
  String location;
  String holiday;
  DateTime date;
  String day;
  int year;
  String displayDate;

  HolidayListData({
    required this.mid,
    required this.location,
    required this.holiday,
    required this.date,
    required this.day,
    required this.year,
    required this.displayDate,
  });

  factory HolidayListData.fromJson(Map<String, dynamic> json) => HolidayListData(
    mid: json["MID"] ?? 0,
    location: json["LOCATION"] ?? '',
    holiday: json["HOLIDAY"] ?? '',
    date: json["DATE"] == null ? DateTime.now() : DateTime.parse(json["DATE"]),
    day: json["DAY"] ?? '',
    year: json["YEAR"] ?? 0,
    displayDate: json["DISPLAY_DATE"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "MID": mid,
    "LOCATION": location,
    "HOLIDAY": holiday,
    "DATE": date.toIso8601String(),
    "DAY": day,
    "YEAR": year,
    "DISPLAY_DATE": displayDate,
  };
}
