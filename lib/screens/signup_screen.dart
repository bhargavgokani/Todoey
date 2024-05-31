import 'dart:convert';
import 'package:todoey/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todoey/screens/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void register() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);
      if (jsonRes['success']) {
      } else {}
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.heightBox,
            const Center(
              child: Text(
                'Welcome to Todoey',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            30.heightBox,
            // const Center(
            //   child: Text(
            //     'Login',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 22,
            //     ),
            //   ),
            // ),
            80.heightBox,
            "Email".text.color(Colors.white).bold.size(18).make(),
            5.heightBox,
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                errorStyle: TextStyle(color: Colors.white),
                // errorText: _isNotValidate ? "Enter Proper Info" : null,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.lightBlueAccent,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "abc@gmail.com",
                hintStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                border: InputBorder.none,
              ),
            ).p4().px24(),
            20.heightBox,
            "Password".text.color(Colors.white).bold.size(18).make(),
            5.heightBox,
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.lightBlueAccent,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "*******",
                hintStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                border: InputBorder.none,
              ),
            ).p4().px24(),
            25.heightBox,
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // padding: EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      register();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: "Register".text.color(Colors.blue).bold.make())
                .box
                .width(context.screenWidth * 0.7)
                .makeCentered()
                .px16()
                .py16(),
          ],
        ),
      ),
    );
  }
}
