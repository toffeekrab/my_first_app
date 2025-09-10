// To parse this JSON data, do
//
//     final custoMerLoginPostRequest = custoMerLoginPostRequestFromJson(jsonString);

import 'dart:convert';

CustoMerLoginPostRequest custoMerLoginPostRequestFromJson(String str) =>
    CustoMerLoginPostRequest.fromJson(json.decode(str));

String custoMerLoginPostRequestToJson(CustoMerLoginPostRequest data) =>
    json.encode(data.toJson());

class CustoMerLoginPostRequest {
  String phone;
  String password;

  CustoMerLoginPostRequest({required this.phone, required this.password});

  factory CustoMerLoginPostRequest.fromJson(Map<String, dynamic> json) =>
      CustoMerLoginPostRequest(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {"phone": phone, "password": password};
}
