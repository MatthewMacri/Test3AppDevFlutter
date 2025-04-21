import 'package:flutter/material.dart';

enum Gender{ male, female}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender? selectedGender;
  final TextEditingController _weightCtrl = TextEditingController();
  double _height = 2.75;
  double? weightNumber;
  double? ageNumber = 0;

  void _calculate() {
    final w = weightNumber;
    if (w == null || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    final bmi = w / (_height * _height);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Your BMI'),
        content: Text(bmi.toStringAsFixed(2) + " $selectedGender"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('BMI Application')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: IconButton(onPressed: (){
                  setState(() {
                    selectedGender = Gender.female;
                  });
                }, icon: Icon(Icons.female, size: 150,))),
                Expanded(child: IconButton(onPressed: (){
                  selectedGender = Gender.male;
                }, icon: Icon(Icons.male, size: 150,)))
              ],
            ),
            Text('Height Slider'),
            Row(
              children: [
                Text(_height.toStringAsFixed(2)),
                Slider(value: _height, onChanged: (double newValue){
                  setState(() {
                    _height = newValue;
                  });
                }, label: _height.toStringAsFixed(2),
                min: 0.0,
                max: 2.5,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Expanded(
            child: Container(
            color: Colors.blueAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,  // ← add this
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Text('Age') ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$ageNumber"),
                      IconButton(onPressed: () {
                        setState(() {
                          ageNumber = ageNumber! - 1;
                        });
                      }, icon: Icon(Icons.minimize)),
                      IconButton(onPressed: () {
                        setState(() {
                          ageNumber = ageNumber! + 1;
                        });
                      }, icon: Icon(Icons.add)),
                    ],
                  ),
                ],
              ),
            ),
      ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,  // ← add this
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Text('Weight') ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$weightNumber"),
                            IconButton(onPressed: () {
                              setState(() {
                                weightNumber = weightNumber! - 1;
                              });
                            }, icon: Icon(Icons.minimize)),
                            IconButton(onPressed: () {
                              setState(() {
                                weightNumber = weightNumber! + 1;
                              });
                            }, icon: Icon(Icons.add)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate BMI'),
            ),
          ],
        ),
      ),
    );
  }
}