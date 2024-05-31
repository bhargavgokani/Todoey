import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey/screens/signup_screen.dart';
import 'package:todoey/screens/tasks_screens.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;

  const MyApp({Key? key, required this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return TaskData();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: determineInitialScreen(),
      ),
    );
  }

  Widget determineInitialScreen() {
    if (token != null && !JwtDecoder.isExpired(token!)) {
      return TaskScreen(token: token!);
    } else {
      return LoginScreen();
    }
  }
}
