import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notes_controller.dart';

class FullNotePage extends StatelessWidget {
  final String noteId;

  const FullNotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note')),
      body: Consumer<NotesController>(
        builder: (context, notesController, _) {
          if (notesController.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final note = notesController.findById(noteId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(note.text, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  'Last edited: ${note.lastEditedDateTime.toString()}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
