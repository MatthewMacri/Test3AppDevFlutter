import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonDecode

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List users= [];

Future<void> fetchUsers() async {
  final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
  List jsonReponse = jsonDecode(response.body);
  setState(() {
    users = jsonReponse.map((user) => User.fromJson(user)).toList();
  });
}


@override
void initState() {
  super.initState();
  fetchUsers();
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
      }),
    );
  }
}

class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json){
    return User(id: json['id'], email: json['email'], name: json['name']);
  }
}


