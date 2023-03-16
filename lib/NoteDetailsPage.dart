// ignore_for_file: use_key_in_widget_constructors, file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:imc/Application/Application.dart';
import 'package:imc/HomePage.dart';

class NoteDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailsPage();
  String mNoteId;
  NoteDetailsPage(this.mNoteId);
}

class _NoteDetailsPage extends State<NoteDetailsPage> with WidgetsBindingObserver {
  // Whether we are editing the current note
  bool mEditing = false;
  // Text editing controller for editing note content
  TextEditingController mTextController = TextEditingController();

  // Heper to focus the note content when we click edit
  FocusNode mTextFieldFocus = FocusNode();

  // Text to speech provider
  FlutterTts mTts = FlutterTts();

  // Application lifecycle tracker, to stop tts when we exit the app
  late AppLifecycleState mLifecycle;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      mLifecycle = state;
    });
    // If we exited the app
    if (state == AppLifecycleState.paused) {
      // Stop the text to speech
      mTts.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    var note = Application.FindById(widget.mNoteId);
    mTextController.text = note.content;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            mTts.stop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text(note.username),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () async {
                setState(() {
                  mEditing = true;
                  FocusScope.of(context).requestFocus(mTextFieldFocus);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              child: const Icon(Icons.play_arrow),
              onTap: () async {
                mTts.speak(note.content);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(note.imagePath),
              TextField(
                decoration: const InputDecoration(border: InputBorder.none, fillColor: Colors.white),
                readOnly: !mEditing,
                controller: mTextController,
                focusNode: mTextFieldFocus,
                maxLines: null,
                textInputAction: TextInputAction.done,
                onSubmitted: (text) {
                  setState(() {
                    note.content = text;
                    mEditing = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
