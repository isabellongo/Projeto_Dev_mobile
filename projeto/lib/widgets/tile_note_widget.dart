import 'package:flutter/material.dart';
import 'edit_note_dialog.dart';
import 'note_widget.dart';

class TileNoteWidget extends NoteWidget {
  const TileNoteWidget({
    super.key,
    required super.titleNote,
    required super.textNote,
    required super.indexNote,
    required super.editNote,
    required super.deleteNote,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Tem certeza de que deseja excluir esta nota?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: const Text('Excluir'),
                onPressed: () {
                  Navigator.of(ctx).pop(); // fecha o diálogo
                  deleteNote(); // chama a função de deletar
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: IconButton(
        icon: const Icon(Icons.edit),
        onPressed:
            () => showDialog(
              context: context,
              builder:
                  (_) =>
                      EditNoteDialog(indexNote: indexNote, textNote: textNote),
            ),
      ),
      title: Text(titleNote),
      subtitle: Text(textNote),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _confirmDelete(context),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
