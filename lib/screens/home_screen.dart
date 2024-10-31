// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart'; // Import AuthProvider
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.uid; // Get user ID from AuthProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login screen after logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: userId == null
            ? const Center(child: Text('User not logged in'))
            : StreamBuilder<List<Note>>(
                stream: notesProvider.getNotesStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final notes = snapshot.data ?? [];
                  return notes.isEmpty
                      ? _buildEmptyState() // Use a separate method for empty state
                      : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              docId:
                                  note.id, // Passes the document ID correctly
                              onDelete: () => _showDeleteConfirmationDialog(
                                  context, notesProvider, note.id),
                            );
                          },
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to build empty state widget
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notes,
            size: 64.0,
            color: Colors.grey,
          ),
          SizedBox(height: 16.0),
          Text(
            'No notes available',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 8.0),
          Text(
            'Tap the + button to add a new note.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, NotesProvider notesProvider, String docId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          title: const Row(
            children: [
              Icon(Icons.warning,
                  color: Colors.red, size: 24.0), // Warning icon
              SizedBox(width: 8.0), // Space between icon and text
              Text('Delete Note', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: const Text(
            'Do you really want to delete this note? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, 
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color for Delete button
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await notesProvider.deleteNote(docId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
