import 'package:firestoretryagain/quiz/quizpage2.dart';
import 'package:flutter/material.dart';

class QuizPage1 extends StatefulWidget {
  const QuizPage1({super.key});

  @override
  State<QuizPage1> createState() => _QuizPage1State();
}

class _QuizPage1State extends State<QuizPage1> {

  incorrectChoice(){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          children: [
            Text('Incorrect choice, try again')
          ],
        ),
      );
    });
  }

  correctChoice(){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          children: [
            Text('Correct Choice')
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Where is Vanier Located'),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: incorrectChoice, child: Text('Boston')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: correctChoice, child: Text('Montreal')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: incorrectChoice, child: Text('New York')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QuizPage2()));
            }, child: Text('Next Question'))
          ],
        ),
      ),
    );
  }
}



