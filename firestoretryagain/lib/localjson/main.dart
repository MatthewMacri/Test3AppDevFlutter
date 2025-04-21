import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Display(),
    );
  }
}

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  
  List users = [];


  @override
  void initState() {
    super.initState();
    loadLocalJson();
  }

  Future<void> loadLocalJson() async {
    String jsonString = await rootBundle.loadString('assets/users.json');
    List jsonResponse = jsonDecode(jsonString);
    setState(() {
      users = jsonResponse.map((user) => User.fromJson(user)).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
            );
          })
    );
  }
}

class User {
  int id;
  String name;
  String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json){
    return User(id: json["id"], name: json['name'], email: json['email']);
  }
}

