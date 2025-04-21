import 'package:firestoretryagain/bmi/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyDm_X6Ezr_OOGbsTVxIErxs3TOpi-6lNDo",
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
      home: LetsDisplayData(),
    );
  }
}

class LetsDisplayData extends StatefulWidget {
  const LetsDisplayData({super.key});

  @override
  State<LetsDisplayData> createState() => _LetsDisplayDataState();
}

class _LetsDisplayDataState extends State<LetsDisplayData> {

  String username = "";
  String countryName = "";
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Users').snapshots();

  Future<void> delete(String docId) async{
    try {
      await users.doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> create() async {
    try {
      await users.add({
        'name': username
      });
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCountry(String docID, String countryName) async {
    try {
      await users.doc(docID).collection('Country').add({
        'countryName': countryName
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
      appBar: AppBar(
        title: Text('Test 3'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300,
              child: TextFormField(
                onChanged: (value) {
                  username = value;
                },
                decoration: InputDecoration(
                    hintText: 'Username'
                ),
              ),
            ),
            ElevatedButton(onPressed: () {
              create();
            }, child: Text('Create')),
            StreamBuilder<QuerySnapshot>(stream: _usersStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('There is an error');
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  String docID = document.id;
                  return ListTile(
                    title: Text(data['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              content: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      countryName = value;
                                    },
                                  ),
                                  ElevatedButton(onPressed: () {
                                    addCountry(docID, countryName);
                                    Navigator.of(context).pop();
                                  }, child: Text('Submit')),
                                ],
                              ),
                            );
                          });
                        },icon: Icon(Icons.add)),
                        IconButton(onPressed: () {
                          delete(docID);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DisplayedPage(docID: docID)));
                        }, icon: Icon(Icons.next_plan)),
                      ],
                    ),
                  );
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }
}

class DisplayedPage extends StatefulWidget {
  final String docID;
  const DisplayedPage({required this.docID, super.key});

  @override
  State<DisplayedPage> createState() => _DisplayedPageState();
}

class _DisplayedPageState extends State<DisplayedPage> {
  late final Stream<QuerySnapshot> countriesStream;

  @override
  void initState() {
    super.initState();
    countriesStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.docID)
        .collection('Country')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Countries')),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: countriesStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('An Error has occurred');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['countryName']),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


