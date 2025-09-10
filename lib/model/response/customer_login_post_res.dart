// To parse this JSON data, do
//
//     final custoMerLoginPostResponse = custoMerLoginPostResponseFromJson(jsonString);

import 'dart:convert';

CustoMerLoginPostResponse custoMerLoginPostResponseFromJson(String str) =>
    CustoMerLoginPostResponse.fromJson(json.decode(str));

String custoMerLoginPostResponseToJson(CustoMerLoginPostResponse data) =>
    json.encode(data.toJson());

class CustoMerLoginPostResponse {
  String message;
  Customer customer;

  CustoMerLoginPostResponse({required this.message, required this.customer});

  factory CustoMerLoginPostResponse.fromJson(Map<String, dynamic> json) =>
      CustoMerLoginPostResponse(
        message: json["message"],
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "customer": customer.toJson(),
  };
}

class Customer {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  Customer({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}
