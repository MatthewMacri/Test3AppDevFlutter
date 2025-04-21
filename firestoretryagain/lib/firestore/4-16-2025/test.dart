import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initalizes the firebase
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDLXk9Wn9T15Xz_GEASdX16oCVvAZrA8v8",
          appId: "183557423786",
          messagingSenderId: "183557423786",
          projectId: "project-3986576144924406315")
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: myFirebaseApp(),
    );
  }
}

class myFirebaseApp extends StatefulWidget {
  const myFirebaseApp({super.key});

  @override
  State<myFirebaseApp> createState() => _myFirebaseAppState();
}

class _myFirebaseAppState extends State<myFirebaseApp> {
  //initalize the firestore to the cloud
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection("Users").snapshots();

  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  final CollectionReference product = FirebaseFirestore.instance.collection("Products");
  String name = '';
  String password = '';

  String productname = '';
  String productbrand = '';
  String userid = '';


  //to create the data
  void _create() async {
    if(name.isNotEmpty && password.isNotEmpty) {
      try {
        // i want to add users first name and last name to the cloud
        await users.add({'name': name, 'password': password});
        print("User addes");
        setState(() {
          name = '';
          password = '';
        });
      } catch (e) {
        print(e);
      }
    } else {
      print("enter a valid name and password");
    }
  }

  Future<void> addProductToUser(String userId, String productName, double price) async{
    try {
      await users.doc(userId).collection('Products').add({
        'name' : productName,
        'price': price
      });
    } catch (e) {
      print(e);
    }
  }

  void createProduct(String productbrand, String productname, String userid) async {
    try {
      // i want to add users first name and last name to the cloud
      await product.add({'productbrand': productbrand, 'productname': productname, 'userid': userid});
      print("User addes");
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  // to retrieve data
  void _retrieve(int id) async {
    // stapshot is the data from the document firestore
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('users').doc("user$id").get();
      print(documentSnapshot.data());

    } catch(e) {
      print(e);
    }
  }

  // update

  void updateUser(String id, String newName, String newPassword) async {
    if(newName.isNotEmpty && newPassword.isNotEmpty) {
      try {
        await users.doc(id).update({'name': newName, 'password': newPassword});
      }
      catch (e) {
        print(e);
      }
    } else {
      print("Enter a valid name and password");
    }
  }
  // delete

  Future<void> deleteUser(String id) async {
    try {
      await users.doc(id).delete();
      print("user deleted");
    }
    catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter username", style: TextStyle(fontSize: 20),),
                SizedBox(height: 10,),
                TextField(onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                  decoration: InputDecoration(hintText: "enter the username", contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0
                  ), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6.0)))),),
                SizedBox(height: 10,),
                Text("Enter password", style: TextStyle(fontSize: 20),),
                SizedBox(height: 10,),
                TextField(onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                  decoration: InputDecoration(hintText: "enter the password", contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0
                  ), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6.0)))),),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: _create, child: Text("add user")),
                SizedBox(height: 10,),
                StreamBuilder(
                    stream: _userStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {

                      if(snapshot.hasError) {
                        return Text("SOMETHING WENT WRONG !!!");
                      }

                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...");
                      }
                      return ListView(
                          shrinkWrap: true,
                          children:
                          snapshot.data!.docs.map((DocumentSnapshot docuement) {
                            Map<String, dynamic> data =
                            docuement.data()! as Map<String, dynamic>;
                            String docId = docuement.id;
                            return ListTile(
                              title: Text(data['name']),
                              subtitle: Text('password : ${data['password']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context) {
                                      String newName = data['name'];
                                      String newPassword = data['password'];
                                      return AlertDialog(
                                        title: Text('edit uder'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              onChanged: (value) {
                                                newName = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Enter new Name"
                                              ), controller: TextEditingController(
                                              text: data['name'],
                                            ),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                newPassword = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Enter new password"
                                              ), controller: TextEditingController(
                                              text: data['password'],
                                            ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(onPressed: () {
                                            updateUser(docId, newName, newPassword);
                                            Navigator.of(context).pop();
                                          }, child: Text("Update the user"))
                                        ],
                                      );
                                    });
                                  }, icon: Icon(Icons.edit)),
                                  IconButton(onPressed: () {
                                    deleteUser(docId);
                                  }, icon: Icon(Icons.delete)),
                                  IconButton(onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context) {
                                      String productdbrand= '';
                                      String productdescription = '';
                                      return AlertDialog(
                                        title: Text('add product'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              onChanged: (value) {
                                                productdbrand = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Enter brand name"
                                              ), controller: TextEditingController(
                                            ),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                productdescription = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Enter product description"
                                              ), controller: TextEditingController(
                                            ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(onPressed: () {
                                            createProduct(productdbrand,productdescription,docId);
                                            Navigator.of(context).pop();
                                          }, child: Text("Add product"))
                                        ],
                                      );
                                    });
                                  }, icon: Icon(Icons.plus_one)),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String productName = '';
                                          String priceStr = '';
                                          return AlertDialog(
                                            title: Text('Add Product'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (value) => productName = value,
                                                  decoration: InputDecoration(hintText: 'Product Name'),
                                                ),
                                                TextField(
                                                  onChanged: (value) => priceStr = value,
                                                  decoration: InputDecoration(hintText: 'Price'),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  double price = double.tryParse(priceStr) ?? 0;
                                                  addProductToUser(docId, productName, price); // 💡 correct function
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Add'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FutureBuilder<QuerySnapshot>(
                                            future: product.where('userid', isEqualTo: docId).get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return AlertDialog(
                                                  title: Text('See products'),
                                                  content: Center(child: CircularProgressIndicator()),
                                                );
                                              }
                                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                                return AlertDialog(
                                                  title: Text('See products'),
                                                  content: Text('No products found for this user.'),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("Close"),
                                                    )
                                                  ],
                                                );
                                              }

                                              return AlertDialog(
                                                title: Text('See products'),
                                                content: Container(
                                                  width: double.maxFinite,
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: snapshot.data!.docs.map((doc) {
                                                      Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
                                                      return ListTile(
                                                        title: Text(productData['productname']),
                                                        subtitle: Text('Brand: ${productData['productbrand']}'),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Close"),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.remove_red_eye),
                                  ),
                                ],
                              ),
                            );

                          }).toList()
                      );
                    }),
              ],
            ),
          ),
        )
    );
  }
}