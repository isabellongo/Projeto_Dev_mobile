import 'package:flutter/material.dart';
import 'edit_note_dialog.dart';
import 'note_widget.dart';
import '../models/note.dart';

class TileNoteWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddPhoto;

  const TileNoteWidget({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onAddPhoto,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
                  onDelete(); // chama a função de deletar
                },
              ),
            ],
          ),
    );
  }

  void _showEditDialog(BuildContext context) {
    onEdit();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: IconButton(
        icon: const Icon(Icons.edit),
        onPressed:
            () => _showEditDialog(context),
      ),
      title: Text(note.title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _confirmDelete(context),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
