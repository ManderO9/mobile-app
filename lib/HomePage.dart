// ignore_for_file: file_names, non_constant_identifier_names, use_key_in_widget_constructors
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imc/NoteDetailsPage.dart';
import 'Application/Application.dart';
import 'Models/NoteModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create the card to display in the list
  Widget CreateItem(NoteModel model) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(model.username),
          subtitle: Text(model.content, maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: Image.asset(
            model.imagePath,
            width: 50,
            height: 50,
          ),
        ),
      ),
      onLongPress: () async {
        await displayDeleteConfirmation(model.id);
      },
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoteDetailsPage(model.id)));
      },
    );
  }

  String mNewNoteText = "";

  // Display dialog popup
  Future<void> displayDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("New Note"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: "What are you thinking?"),
                    onChanged: ((value) {
                      mNewNoteText = value;
                    }),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    var random = Random();
                    Application.Notes.add(NoteModel(
                      "hossem",
                      mNewNoteText,
                      "assets/images/strawberries.jpeg",
                      random.nextInt(1000000000).toString(),
                    ));

                    mNewNoteText = "";
                    setState(() {});
                  },
                  child: const Text("approve")),
            ],
          );
        });
  }

// Delete confirmation
  Future<void> displayDeleteConfirmation(String noteId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Note"),
            content: const Text("You are sure you want to delete this note?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => Application.Notes.remove(Application.FindById(noteId)));
                },
                child: const Text("delete"),
              ),
            ],
          );
        });
  }

  // Create the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: GestureDetector(
                child: const Icon(Icons.add),
                onTap: () async {
                  await displayDialog();
                },
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: Application.Notes.length,
            itemBuilder: (ctx, i) {
              return CreateItem(Application.Notes[i]);
            }),
      ),
    );
  }
}
