import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey/screens/signup_screen.dart';
import 'package:todoey/screens/tasks_screens.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonRes = jsonDecode(response.body);

      if (jsonRes['success']) {
        var myToken = jsonRes['token'];
        prefs.setString("token", myToken);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskScreen(
                      token: myToken,
                    )));
      } else {
        print("Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            70.heightBox,
            "Login to Todoey".text.white.size(24).makeCentered(),
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
            5.heightBox,
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // padding: EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      loginUser();
                    },
                    child: "Login".text.color(Colors.blue).bold.make())
                .box
                .width(context.screenWidth * 0.7)
                .makeCentered()
                .px16()
                .py16(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignScreen()));
              },
              child: HStack([
                "Create new account  ".text.white.make(),
                // "Sign Up".text.white.make()
              ]).centered(),
            ),
          ],
        ),
      ),
    );
  }
}
