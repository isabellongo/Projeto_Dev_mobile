import 'package:flutter/material.dart';
import './note_widget.dart';

class TileNoteWidget extends NoteWidget {
  const TileNoteWidget({
    super.key,
    required super.titleNote,
    required super.textNote,
    required super.editNote,
    required super.deleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: editNote,
      ),
      title: Text(titleNote),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: deleteNote,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
