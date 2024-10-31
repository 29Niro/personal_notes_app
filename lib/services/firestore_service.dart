// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  static final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  /// Returns a stream of notes for the specified user.
  Stream<List<Note>> getNotes(String userId) {
    return _notesCollection.where('userId', isEqualTo: userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  /// Adds a new note to Firestore.
  Future<void> addNote(Note note) async {
    try {
      await _notesCollection.add(note.toMap());
    } catch (e) {
      print("Error adding note: $e");
      rethrow;
    }
  }

  /// Updates an existing note in Firestore by its document ID.
  Future<void> updateNote(String docId, Note note) async {
    try {
      await _notesCollection.doc(docId).update(note.toMap());
    } catch (e) {
      print("Error updating note: $e");
      rethrow;
    }
  }

  /// Deletes a note from Firestore by its document ID.
  Future<void> deleteNote(String docId) async {
    try {
      await _notesCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting note: $e");
      rethrow;
    }
  }
}
