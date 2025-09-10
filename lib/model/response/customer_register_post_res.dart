// To parse this JSON data, do
//
//     final customerLoginPostResponse = customerLoginPostResponseFromJson(jsonString);

import 'dart:convert';
CustomerRegisterPostResponse customerRegisterPostResponseFromJson(String str) =>
    CustomerRegisterPostResponse.fromJson(json.decode(str));

String customerRegisterPostResponseToJson(CustomerRegisterPostResponse data) =>
    json.encode(data.toJson());
class CustomerRegisterPostResponse {
  String message;
  int id;

  CustomerRegisterPostResponse({required this.message, required this.id});

  factory CustomerRegisterPostResponse.fromJson(Map<String, dynamic> json) {
    return CustomerRegisterPostResponse(
      message: json["message"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
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
