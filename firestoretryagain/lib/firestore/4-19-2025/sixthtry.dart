import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyDm_X6Ezr_OOGbsTVxIErxs3TOpi-6lNDo",
      appId: "594082293879",
      messagingSenderId: "594082293879",
      projectId: "firestore-81cfc"
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LetsDisplay(),
    );
  }
}

class LetsDisplay extends StatefulWidget {
  const LetsDisplay({super.key});

  @override
  State<LetsDisplay> createState() => _LetsDisplayState();
}

class _LetsDisplayState extends State<LetsDisplay> {
  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance.collection('Users').snapshots();
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String countryName = "";

  Future<void> delete(String docID) async{
    try {
      await users.doc(docID).delete();
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCountry(String docID, String countryName) async{
    try {
      await users.doc(docID).collection('Country').add({
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
           StreamBuilder<QuerySnapshot>(stream: userStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
             return ListView(
               shrinkWrap: true,
               children: snapshot.data!.docs.map(((DocumentSnapshot document) {
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
                             content: Column(
                               children: [
                                 TextFormField(
                                   decoration: InputDecoration(
                                     hintText: 'Enter your Country'
                                   ),
                                   onChanged: (value) {
                                     countryName = value;
                                   },
                                 ),
                                 ElevatedButton(onPressed: () {
                                   addCountry(docID, countryName);
                                 }, child: Text('Submit'))
                               ],
                             ),
                           );
                         });
                       }, icon: Icon(Icons.add)),
                       IconButton(onPressed: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ViewOnSecondPage(id: docID)));
                       }, icon: Icon(Icons.view_agenda)),
                       IconButton(onPressed: () {
                         delete(docID);
                       }, icon: Icon(Icons.delete))
                     ],
                   ),
                 );
               })).toList(),
             );
           })
         ],
       ),
     ),
    );
  }
}

class ViewOnSecondPage extends StatefulWidget {
  final String id;
  const ViewOnSecondPage({required this.id, super.key});

  @override
  State<ViewOnSecondPage> createState() => _ViewOnSecondPageState();
}

class _ViewOnSecondPageState extends State<ViewOnSecondPage> {

  late final CollectionReference country;
  late final Stream<QuerySnapshot> countryStream;

  @override
  void initState() {
    country = FirebaseFirestore.instance.collection('Users').doc(widget.id).collection('Country');
    countryStream = country.snapshots();
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
            Expanded(child: StreamBuilder<QuerySnapshot>(stream: countryStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
      )
      );
  }
}
