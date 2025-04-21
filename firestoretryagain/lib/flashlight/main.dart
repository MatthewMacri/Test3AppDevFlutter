import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main () {
runApp(MyApp());
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

  Future<void> _enableTorch(BuildContext context) async{
      try {
        await TorchLight.enableTorch();
      } catch (e) {
        print(e);
      }
  }

  Future<void> _disableTorch(BuildContext context) async{
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _isTorchAvailable(BuildContext context) async{
    try {
      return await TorchLight.isTorchAvailable();
    } catch (e) {
      print(e);
    }
    throw();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: _isTorchAvailable(context), builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData && snapshot.data!){
          return Column(
            children: [
              Expanded(child: Center(child: ElevatedButton(onPressed: () async {
                _enableTorch(context);
              }, child: Text('Enable Torch')),)),
              Expanded(child: Center(child: ElevatedButton(onPressed: () async {
                _disableTorch(context);
              }, child: Text('Disable Torch')),))
            ],
          );
        } else if (snapshot.hasError){
          return Center(child: Text('Torch not available'),);
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }),
    );
  }
}

