import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/components/note_tile.dart';
import 'package:flutternotes/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Note",
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.grey.shade600),
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero))),
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addNote(textController.text);
                      } else {
                        firestoreService.updateNote(docID, textController.text);
                      }

                      textController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Notes",
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
        onPressed: openNoteBox,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                  padding: const EdgeInsets.only(top: 5, bottom: 25),
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];
                    String docID = document.id;

                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String noteText = data["note"];

                    return NoteTile(
                        noteText: noteText,
                        deleteNote: () => firestoreService.deleteNote(docID),
                        editNote: () => openNoteBox(docID: docID));
                  });
            } else {
              return const Text("Error");
            }
          }),
    );
  }
}
