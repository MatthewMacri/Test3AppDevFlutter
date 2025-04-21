import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
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
      debugShowCheckedModeBanner: false,
      home: DisplayingPage7(),
    );
  }
}

class DisplayingPage7 extends StatefulWidget {
  const DisplayingPage7({super.key});

  @override
  State<DisplayingPage7> createState() => _DisplayingPage7State();
}

class _DisplayingPage7State extends State<DisplayingPage7> {

  String name = "";
  String countryName = "";

  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance.collection('Users').snapshots();

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');


  Future<void> create() async{
    try {
      await users.add({
        'name': name
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
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCountry(String docID, String countryname) async {
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
      appBar: AppBar(title: Text('Database'), centerTitle: true,),
      body: Center(
        child: Column(
          children: [

            Container(
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter your Username'
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
            ),
            
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              create();
            }, child: Text('Submit')),

            StreamBuilder<QuerySnapshot>(stream: userStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Error has occured');
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
                            return AlertDialog(
                              content: Container(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(hintText: 'Enter the country name'),
                                      onChanged: (value) {
                                        countryName = value;
                                      },
                                    ),
                                    SizedBox(height: 20,),
                                    ElevatedButton(onPressed: () {
                                      addCountry(docID, countryName);
                                      Navigator.pop(context);
                                    }, child: Text('Submit'))
                                  ],
                                ),
                              ),
                            );
                          });
                        }, icon: Icon(Icons.add)),
                        IconButton(onPressed: () {
                          delete(docID);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DisplayOnSecondPage(docID: docID)));
                        }, icon: Icon(Icons.view_agenda)),
                      ],
                    ),
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

class DisplayOnSecondPage extends StatefulWidget {
  final String docID;
  const DisplayOnSecondPage({required this.docID, super.key});


  @override
  State<DisplayOnSecondPage> createState() => _DisplayOnSecondPageState();
}

class _DisplayOnSecondPageState extends State<DisplayOnSecondPage> {

  late final Stream<QuerySnapshot> countryStream;


  @override
  void initState() {
    countryStream = FirebaseFirestore.instance.collection('Users').doc(widget.docID).collection('Country').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.keyboard_return))
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(stream: countryStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                  return ListTile(
                    title: Text(data['countryName']),
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


