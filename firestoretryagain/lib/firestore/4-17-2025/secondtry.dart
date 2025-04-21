import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDm_X6Ezr_OOGbsTVxIErxs3TOpi-6lNDo",
        appId: "594082293879",
        messagingSenderId: "594082293879",
        projectId: "firestore-81cfc")
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  String name = "";
  String country = "";

  void _create() async {
    if (name.isNotEmpty && country.isNotEmpty) {
      try {
        final DocumentReference newUser = await users.add({'name': name});
        await newUser.collection('Country').add({
          'countryName': country,
        });
        setState(() {
          name = "";
          country = "";
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addCountry(String userId, String countryName) async{
    try {
      await users.doc(userId).collection('Country').add({
        "countryName": countryName
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter your name'),
            onChanged: (value) {
                name = value;
            },
            ),
          ),
          Container(
            width: 300,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter your Country'),
            onChanged: (value) {
                country = value;
            },
            ),
          ),
          ElevatedButton(onPressed: () {
            _create();
          }, child: Text('Submit')),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('An error occurred'));
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
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
                              String newCountry = "";
                              final controller = TextEditingController();
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      onChanged: (value) => newCountry = value,
                                      controller: controller,
                                    ),

                                  ],
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      ElevatedButton(onPressed: () {
                                        addCountry(docId, newCountry);
                                      }, child: Text('Add Country')),
                                      IconButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, icon: Icon(Icons.keyboard_return))
                                    ],
                                  )
                                ],
                              );
                            });
                          }, icon: Icon(Icons.add)),
                          IconButton(onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SecondPage(docId: docId)));
                          }, icon: Icon(Icons.transit_enterexit)),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
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
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(stream: _countries, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text('Error has been made');
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }

            return Expanded(child: ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    ListTile(
                      title: Text(data['countryName']),
                    ),
                  ],
                );
              }).toList(),
            ));
          }),
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.keyboard_return))
        ],
      ),
    );
  }


}



