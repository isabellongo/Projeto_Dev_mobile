import 'package:flutter/material.dart';
import 'package:projeto/widgets/edit_note_dialog.dart';
import './note_widget.dart';
//import './add_note_dialog.dart';

class TileNoteWidget extends NoteWidget {

  const TileNoteWidget({
    super.key,
    required super.titleNote,
    required super.textNote,
    required super.indexNote,
    required super.editNote,
    required super.deleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => EditNoteDialog(
            indexNote: indexNote,
            textNote: textNote),
        ),
      ),
      title: Text(textNote),
      subtitle: Text(titleNote),
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



