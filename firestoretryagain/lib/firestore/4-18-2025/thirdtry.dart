import 'package:firestoretryagain/bmi/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyDm_X6Ezr_OOGbsTVxIErxs3TOpi-6lND",
      appId: "594082293879",
      messagingSenderId: "594082293879",
      projectId: "firestore-81cfc"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DisplayDatabase(),
    );
  }
}

class DisplayDatabase extends StatefulWidget {
  const DisplayDatabase({super.key});

  @override
  State<DisplayDatabase> createState() => _DisplayDatabaseState();
}

class _DisplayDatabaseState extends State<DisplayDatabase> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _users = FirebaseFirestore.instance.collection('Users').snapshots();
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String username = "";
  String country = "";

  void _create() async {
    await users.add({
      "name": username
    });
    setState(() {
      username = "";
    });
  }

  Future<void> delete(String id) async {
    try {
      await users.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCountry(String userId, String countryName) async{
    try {
      await users.doc(userId).collection('Country').add({
        "countryName": countryName
      });
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Enter your username'),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  ElevatedButton(onPressed: () {
                    _create();
                  },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),)
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(stream: _users, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('An error has occur');
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }



              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  String docId = document.id;
                  return ListTile(
                    title: Text(data['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      country = value;
                                    },
                                  ),
                                  IconButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, icon: Icon(Icons.keyboard_return))
                                ],
                              ),
                              actions: [
                                ElevatedButton(onPressed: () {
                                  addCountry(docId, country);
                                }, child: Text('Add country'))
                              ],
                            );
                          });
                        }, icon: Icon(Icons.add)),
                        IconButton(onPressed: () {
                          delete(docId);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NextPage(docId: docId)));
                        }, icon: Icon(Icons.next_plan))
                      ],
                    )
                  );
                }).toList(),
              );
            }),

          ],
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  final String docId;
  const NextPage({required this.docId, super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  late final Stream<QuerySnapshot> _countries;


  @override
  void initState() {
    super.initState();
    _countries = FirebaseFirestore.instance.collection('Users').doc(widget.docId).collection('Country').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(stream: _countries, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('An error has occured');
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(data["countryName"]),
                      ),

                    ],
                  );
                }).toList(),
              );
            }),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Icon(Icons.keyboard_return))
          ],
        ),
      ),
    );
  }
}


