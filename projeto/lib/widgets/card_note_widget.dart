import 'package:flutter/material.dart';
import './note_widget.dart';

class CardNoteWidget extends NoteWidget {
  const CardNoteWidget({
    super.key,
    required super.titleNote,
    required super.textNote,
    required super.editNote,
    required super.deleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Ink(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: editNote,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    titleNote,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: deleteNote,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
