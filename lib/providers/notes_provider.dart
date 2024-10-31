import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Stream<List<Note>> getNotesStream(String userId) {
    return notesCollection.where('userId', isEqualTo: userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  Future<void> fetchNotes(String userId) async {
    final snapshot =
        await notesCollection.where('userId', isEqualTo: userId).get();
    _notes = snapshot.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await notesCollection.add(note.toMap());
    fetchNotes(note.userId);
  }

  Future<void> updateNote(String docId, Note note) async {
    await notesCollection.doc(docId).update(note.toMap());
    fetchNotes(note.userId);
  }

  Future<void> deleteNote(String docId) async {
    await notesCollection.doc(docId).delete();
    _notes.removeWhere((note) => note.id == docId);
    notifyListeners();
  }
}
