import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EditScreen());
}

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'My Notes',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final CollectionReference _cafe =
      FirebaseFirestore.instance.collection('Notes');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['title'];
      _descController.text = documentSnapshot['description'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'title'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'description',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? title = _nameController.text;
                    final String? description = _descController.text;

                    if (title != null && description != null) {
                      if (action == 'create') {
                        // Persist a new cafe to Firestore
                        await _cafe
                            .add({"title": title, "description": description});
                      }

                      if (action == 'update') {
                        // Update the cafe
                        await _cafe.doc(documentSnapshot!.id).update(
                            {"title": title, "description": description});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _descController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _cafe.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted notes')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('My Notes'),
      ),
      // Using StreamBuilder to display all notes from Firestore in real-time
      body: StreamBuilder(
        stream: _cafe.snapshots(),
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
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single cafe
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single cafe
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
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
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
