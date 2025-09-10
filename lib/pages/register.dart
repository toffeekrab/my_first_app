import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/customer_register_post_req.dart';
import 'package:my_first_app/model/response/customer_register_post_res.dart';
import 'package:my_first_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String text = '';
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController confirmCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ชื่อ-นามสกุล
              fieldLabel("ชื่อ-นามสกุล", nameCtl),
              const SizedBox(height: 8),
              // หมายเลขโทรศัพท์
              fieldLabel(
                "หมายเลขโทรศัพท์",
                phoneCtl,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              // อีเมล์
              fieldLabel(
                "อีเมล์",
                emailCtl,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              // รหัสผ่าน
              fieldLabel("รหัสผ่าน", passwordCtl, obscure: true),
              const SizedBox(height: 8),
              // ยืนยันรหัสผ่าน
              fieldLabel("ยืนยันรหัสผ่าน", confirmCtl, obscure: true),
              const SizedBox(height: 16),
              // ปุ่มสมัครสมาชิก
              FilledButton(
                onPressed: register,
                child: const Text(
                  'สมัครสมาชิก',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'หากมีบัญชีอยู่แล้ว?',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ข้อความ error / success
              Text(
                text,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldLabel(
    String label,
    TextEditingController ctl, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        TextField(
          controller: ctl,
          obscureText: obscure,
          keyboardType: keyboard,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  void register() async {
    final name = nameCtl.text.trim();
    final phone = phoneCtl.text.trim();
    final email = emailCtl.text.trim();
    final password = passwordCtl.text;
    final confirm = confirmCtl.text;

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      setState(() => text = "กรุณากรอกข้อมูลให้ครบทุกช่อง");
      return;
    }
    if (password != confirm) {
      setState(() => text = "รหัสผ่านไม่ตรงกัน");
      return;
    }

    final req = CustoMerRegisterPostRequest(
      fullname: name,
      phone: phone,
      email: email,
      password: password,
      image: '', // placeholder
    );

    try {
      final res = await http.post(
        Uri.parse("http://172.18.1.32:3000/customers"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: custoMerRegisterPostRequestToJson(req),
      );

      log("Response body: ${res.body}");

      if (res.statusCode == 200) {
        final dataIn = customerRegisterPostResponseFromJson(res.body);
        setState(() => text = dataIn.message);

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        });
      } else {
        setState(() {
          text = "เกิดข้อผิดพลาด: ${res.statusCode} ${res.body}";
        });
      }
    } catch (e) {
      setState(() => text = "ไม่สามารถเชื่อมต่อ server ได้");
      log("Register error: $e");
    }
  }
}
