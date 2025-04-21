import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _doneTask1 = false;
  bool _doneTask2 = false;
  bool _doneTask3 = false;

  void _toggleDoneTask1() {
    setState(() {
      _doneTask1 = !_doneTask1;
    });
  }

  void _toggleDoneTask2() {
    setState(() {
      _doneTask2 = !_doneTask2;
    });
  }

  void _toggleDoneTask3() {
    setState(() {
      _doneTask3 = !_doneTask3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: _toggleDoneTask1, child: Text('Clean My Car', style: TextStyle(decoration: _doneTask1 ? TextDecoration.lineThrough : TextDecoration.none, decorationThickness: 2,),)),
            SizedBox(height: 20,),
            TextButton(onPressed: _toggleDoneTask2, child: Text('Pay Credit Card', style: TextStyle(decoration: _doneTask2 ? TextDecoration.lineThrough : TextDecoration.none, decorationThickness: 2,))),
            SizedBox(height: 20,),
            TextButton(onPressed: _toggleDoneTask3, child: Text('Study for App Dev', style: TextStyle(decoration: _doneTask3 ? TextDecoration.lineThrough : TextDecoration.none, decorationThickness: 2,))),
          ],
        ),
      ),
    );
  }
}




