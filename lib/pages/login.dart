import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/register.dart';
import 'package:my_first_app/pages/showtrip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  final String correctPhone = '0812345678';
  final String correctPassword = '1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              GestureDetector(
                onDoubleTap: () => login(),
                child: Image.asset('assets/logo.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'หมายเลขโทรศัพท์',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneNoCtl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รหัสผ่าน',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: register,
                      child: const Text(
                        'ลงทะเบียนใหม่',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    FilledButton(
                      onPressed: login,
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(fontSize: 20, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login() async {
    var data = {"phone": "0817399999", "password": "1111"};
    CustoMerLoginPostRequest req = CustoMerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    http
        .post(
          Uri.parse("http://172.18.1.32:3000/customers/login"),
          // Uri.parse("$url/customers/login"),
          // Uri.parse("$API_ENDPOINT/customer/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: custoMerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          //value = json string
          var dataIn = custoMerLoginPostResponseFromJson(value.body);
          log(dataIn.customer.fullname);
          log(dataIn.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowTripPage(cid: dataIn.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
