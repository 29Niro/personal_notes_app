import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart'; // Import AuthProvider

class NoteScreen extends StatefulWidget {
  final String? docId;

  const NoteScreen({super.key, this.docId});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      _isEditing = true;
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final note =
          notesProvider.notes.firstWhere((note) => note.id == widget.docId);
      _titleController.text = note.title;
      _contentController.text = note.content;
    }
  }

  Future<void> _saveNote() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final userId = authProvider.user?.uid;

    if (userId == null) {
      // Handle the case where the user is not logged in (optional)
      return;
    }

    final note = Note(
      id: widget.docId ?? '', // Empty if it's a new note
      userId: userId, // Use actual user ID
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
    );

    if (_isEditing && widget.docId != null) {
      await notesProvider.updateNote(widget.docId!, note);
    } else {
      await notesProvider.addNote(note);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
