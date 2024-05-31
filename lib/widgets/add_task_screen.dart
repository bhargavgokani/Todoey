import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todoey/models/task.dart';
import 'package:velocity_x/velocity_x.dart';

import '../config.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _todoTitle = TextEditingController();

  TextEditingController _todoDesc = TextEditingController();
  bool _isNotValidate = false;

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty) {
      var regBody = {
        // "userId": userId,
        "title": _todoTitle.text,
        // "password": passwordController.text
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
    String newTaskTitle = '';
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0xff1D5A75),
                  fontWeight: FontWeight.w500),
            ),
            TextFormField(
              controller: _todoTitle,
              // autofocus: true,
              decoration: const InputDecoration(hintText: "Add Title"),
              textAlign: TextAlign.center,
              onChanged: (taskTitle) {
                newTaskTitle = taskTitle;
              },
            ),
            // TextFormField(
            //   // autofocus: true,
            //   decoration: const InputDecoration(hintText: "Add Description"),
            //   textAlign: TextAlign.center,
            //   onChanged: (taskTitle) {
            //     newTaskTitle = taskTitle;
            //   },
            // ),
            5.heightBox,
            TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              onPressed: () {
                Provider.of<TaskData>(context, listen: false)
                    .addTask(newTaskTitle);
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
