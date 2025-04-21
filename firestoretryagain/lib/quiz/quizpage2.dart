import 'package:flutter/material.dart';

class QuizPage2 extends StatefulWidget {
  const QuizPage2({super.key});

  @override
  State<QuizPage2> createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {

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
            Text('What sport team is the Montreal Canadians'),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: correctChoice, child: Text('Hockey')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: incorrectChoice, child: Text('Soccer')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: incorrectChoice, child: Text('Football')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QuizPage2()));
            }, child: Icon(Icons.arrow_right_alt)),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: Icon(Icons.arrow_back))
          ],
        ),
      ),
    );
  }
}



