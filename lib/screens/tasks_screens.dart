import 'package:flutter/material.dart';
import 'package:todoey/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../config.dart';

class TaskScreen extends StatefulWidget {
  final token;
  const TaskScreen({required this.token, Key? key}) : super(key: key);
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // late final GestureLongPressCallback? onLongPress;

  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "discription": _todoDesc.text
      };
      var response = await http.post(Uri.parse(createTodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonRes = jsonDecode(response.body);
      print(jsonRes['success']);
      if (jsonRes['success']) {
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print("Something went wrong");
      }
    }
  }

  void getTodoList(userId) async {
    var regBody = {"userId": userId};
    var response = await http.get(
      Uri.parse(getTodo),
      // headers: {"Content-Type": "application/json"},
      // body: jsonEncode(regBody),
    );

    var jsonRes = jsonDecode(response.body);
    items = jsonRes['data'];
    if (items == null) {
      print("null");
    } else {
      print(response.body);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.lightBlueAccent,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     showModalBottomSheet(
      //         context: context,
      //         isScrollControlled: true,
      //         builder: (context) => SingleChildScrollView(
      //               child: Container(
      //                 padding: EdgeInsets.only(
      //                     bottom: MediaQuery.of(context).viewInsets.bottom),
      //                 child: AddTaskScreen(),
      //               ),
      //             ));
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.list,
                    size: 35,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // 10.heighbox(),
                const Text(
                  'Todoey',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w700),
                ),

                Text(
                  '${Provider.of<TaskData>(context).taskCount} task',
                  style: const TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // height: 300.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              //todoey app
              // child: TasksList(),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: "Then".text.make(),
                child: items == null
                    ? userId.text.make()
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    onPressed: (BuildContext context) {
                                      // print('${items![index]['_id']}');
                                      // deleteItem('${items![index]['_id']}');
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                borderOnForeground: false,
                                child: ListTile(
                                  leading: const Icon(Icons.task),
                                  title: Text('${items![index]['title']}'),
                                  subtitle: Text(''),
                                  trailing: const Icon(Icons.arrow_back),
                                ),
                              ));
                        },
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Add To-Do'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _todoTitle,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Title",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _todoDesc,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        addTodo();
                      },
                      child: const Text(
                        "Add",
                      ))
                ],
              ));
        });
  }
}
