import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final String docId;
  final VoidCallback onDelete; // Add onDelete callback

  const NoteCard({
    Key? key,
    required this.note,
    required this.docId,
    required this.onDelete, // Accept it as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                print('hii' + docId);
                Navigator.pushNamed(context, '/note',
                    arguments: {'docId': docId});
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete, // Call the delete callback
            ),
          ],
        ),
      ),
    );
  }
}
