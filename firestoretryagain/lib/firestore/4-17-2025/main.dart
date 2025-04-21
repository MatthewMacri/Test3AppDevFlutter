import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDm_X6Ezr_OOGbsTVxIErxs3TOpi-6lNDo",
          appId: "594082293879",
          messagingSenderId: "594082293879",
          projectId: "firestore-81cfc")
  );
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
FirebaseFirestore firestore = FirebaseFirestore.instance;

final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Users').snapshots();

final CollectionReference users = FirebaseFirestore.instance.collection('Users');

Future<void> addSubCollection(String userId, String countryName) async{
  try {
    await users.doc(userId).collection('Country').add({
      "countryName": countryName,
    });
  } catch (e){
    print(e);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(stream: _userStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasError){
                  return Text('Data is invalid');
                }

                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }

                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    String docID = document.id;
                    return ListTile(
                      title: Text(data['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {
                            showDialog(context: context, builder: (BuildContext context) {
                              String newCountryName = '';
                              final controller = TextEditingController();
                              return AlertDialog(
                                title: Text('Add a country'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      onChanged: (value) => newCountryName = value,
                                      decoration: InputDecoration(hintText: 'Enter new Country'),
                                      controller: controller,)
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(onPressed: () {
                                    addSubCollection(docID, newCountryName);
                                    Navigator.of(context).pop();
                                    },
                                      child: Text("Update the user"))
                                ],
                              );
                            });
                          }, icon: Icon(Icons.add)),
                          IconButton(onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SecondPage(docId: docID)));
                          }, icon: Icon(Icons.change_circle))
                        ],
                      ),
                    );
                  }).toList(),
                );
              })
            ],
          ),
        ),
      )
    );
  }
}

class SecondPage extends StatefulWidget {
  final String docId;
  const SecondPage({required this.docId, super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();

}

class _SecondPageState extends State<SecondPage> {

  late final Stream<QuerySnapshot> _countries;

  @override
  void initState() {
    super.initState();
    _countries = FirebaseFirestore.instance.collection('Users').doc(widget.docId).collection('Country').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(stream: _countries, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Data has an error');
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }

              return Expanded(child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                      title: Text(data['countryName']),
                        ),
                      IconButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.keyboard_return))
                    ],
                  );
                }).toList(),
              ));
            })
          ],
        ),
      ),
    );
  }
}




