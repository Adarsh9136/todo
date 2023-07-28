import 'package:mvvm_todo/screens/home_screen.dart';
import 'package:mvvm_todo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBpXV07Gz69lVPWcNfF9sspOhIrgKjkF8s",
        appId: "1:659763173962:web:9bdaa395e1e9f5bd8564b3",
        messagingSenderId: "659763173962",
        projectId: "todo-app-2ef85")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:FirebaseAuth.instance.currentUser==null?LoginPage():HomePage(),
    );
  }
}