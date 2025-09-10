// To parse this JSON data, do
//
//     final custoMerRegisterPostRequest = custoMerRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

CustoMerRegisterPostRequest custoMerRegisterPostRequestFromJson(String str) =>
    CustoMerRegisterPostRequest.fromJson(json.decode(str));

String custoMerRegisterPostRequestToJson(CustoMerRegisterPostRequest data) =>
    json.encode(data.toJson());

class CustoMerRegisterPostRequest {
  String fullname;
  String phone;
  String email;
  String image;
  String password;

  CustoMerRegisterPostRequest({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
  });

  factory CustoMerRegisterPostRequest.fromJson(Map<String, dynamic> json) =>
      CustoMerRegisterPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
    "password": password,
  };
}
