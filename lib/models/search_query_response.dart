// To parse this JSON data, do
//
//     final searchQueryModel = searchQueryModelFromJson(jsonString);

import 'dart:convert';

SearchQueryResponse searchQueryModelFromJson(String str) => SearchQueryResponse.fromJson(json.decode(str));

String searchQueryModelToJson(SearchQueryResponse data) => json.encode(data.toJson());

class SearchQueryResponse {
  int? totalCount;
  List<SearchQueryResponseData>? data;

  SearchQueryResponse({
    this.totalCount,
    this.data,
  });

  factory SearchQueryResponse.fromJson(Map<String, dynamic> json) => SearchQueryResponse(
    totalCount: json["total count"],
    data: json["data"] == null ? [] : List<SearchQueryResponseData>.from(json["data"]!.map((x) => SearchQueryResponseData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total count": totalCount,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchQueryResponseData {
  int? id;
  String? title;
  String? company;
  String? companyLocation;
  String? logo;
  dynamic salary;
  String? jobPosted;
  String? jobType;
  String? button1Title;
  String? button1Href;
  String? button2Title;
  String? button2Href;
  String? jobDescription;

  SearchQueryResponseData({
    this.id,
    this.title,
    this.company,
    this.companyLocation,
    this.logo,
    this.salary,
    this.jobPosted,
    this.jobType,
    this.button1Title,
    this.button1Href,
    this.button2Title,
    this.button2Href,
    this.jobDescription,
  });

  factory SearchQueryResponseData.fromJson(Map<String, dynamic> json) => SearchQueryResponseData(
    id: json["id"],
    title: json["title"],
    company: json["company"],
    companyLocation: json["companyLocation"],
    logo: json["logo"],
    salary: json["salary"],
    jobPosted: json["jobPosted"],
    jobType: json["jobType"],
    button1Title: json["button1Title"],
    button1Href: json["button1Href"],
    button2Title: json["button2Title"],
    button2Href: json["button2Href"],
    jobDescription: json["jobDescription"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title": title,
    "company": company,
    "companyLocation": companyLocation,
    "logo": logo,
    "salary": salary,
    "jobPosted": jobPosted,
    "jobType": jobType,
    "button1Title": button1Title,
    "button1Href": button1Href,
    "button2Title": button2Title,
    "button2Href": button2Href,
    "jobDescription": jobDescription,
  };
}
