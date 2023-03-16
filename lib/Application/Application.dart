// ignore_for_file: file_names, non_constant_identifier_names
import '../Models/NoteModel.dart';

class Application {
  // The list of all notes in the app
  static List<NoteModel> Notes = <NoteModel>[];

// Returns the note with the specified id
  static NoteModel FindById(String noteId) {
    NoteModel note = NoteModel("", "", "", "");
    for (int i = 0; i < Notes.length; ++i) {
      if (Notes[i].id == noteId) {
        note = Notes[i];
        break;
      }
    }
    return note;
  }

  static Init() {}
}
