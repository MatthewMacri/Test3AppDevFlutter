import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
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
      home: ScreenThatDiplays(),
    );
  }
}

class ScreenThatDiplays extends StatefulWidget {
  const ScreenThatDiplays({super.key});

  @override
  State<ScreenThatDiplays> createState() => _ScreenThatDiplaysState();
}

class _ScreenThatDiplaysState extends State<ScreenThatDiplays> {

  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance.collection('Users').snapshots();
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String username = "";
  String countryName = "";

  Future<void> create() async{
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

  Future<void> delete(String docID) async {
    try {
      await users.doc(docID).delete();
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
      appBar: AppBar(title: Text('Display Data'),),
      body: Center(
        child: Column(
          children: [

            Container(
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Username'
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
            ),

            ElevatedButton(onPressed: () {
              create();
            }, child: Text('Submit')),

            StreamBuilder<QuerySnapshot>(stream: userStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if(snapshot.hasError){
                return Text('An Error Has Occured');
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
                          delete(docID);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: () {
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(

                              content: Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Enter the country name'
                                      ),
                                      onChanged: (value) {
                                        countryName = value;
                                      },
                                    ),
                                    ElevatedButton(onPressed: () {
                                      addCountry(docID, countryName);
                                      Navigator.of(context).pop();
                                    }, child: Text('Submit'),)
                                  ],
                                ),
                              )
                            );
                          });
                        }, icon: Icon(Icons.add)),
                        IconButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DisplayedOnSecondScreen(id: docID)));
                        }, icon: Icon(Icons.view_agenda)),
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

class DisplayedOnSecondScreen extends StatefulWidget {
  final String id;
  const DisplayedOnSecondScreen({required this.id, super.key});

  @override
  State<DisplayedOnSecondScreen> createState() => _DisplayedOnSecondScreenState();
}

class _DisplayedOnSecondScreenState extends State<DisplayedOnSecondScreen> {

  late final CollectionReference country;
  late final Stream<QuerySnapshot> _country;

  @override
  void initState() {
    country = FirebaseFirestore.instance.collection('Users').doc(widget.id).collection('Country');
    _country = country.snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.keyboard_return)),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: StreamBuilder<QuerySnapshot>(stream: _country, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['countryName']),
              );
            }).toList(),
          );
        }
        ),
      ),
          ],
        ),
      ),
    );
  }


}


