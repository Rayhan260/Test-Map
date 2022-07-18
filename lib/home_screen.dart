import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var firestoreDB = FirebaseFirestore.instance.collection('Notes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Notes"),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: firestoreDB,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(documentSnapshot['description']),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
