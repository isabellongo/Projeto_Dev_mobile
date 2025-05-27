import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/notes_controller.dart';
import '../widgets/tile_note_widget.dart';
import '../widgets/add_note_dialog.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Future<void> _logout() async {
    final controller = context.read<AuthController>();
    await controller.signOut();
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os PDFs'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: Consumer<NotesController>(
        builder: (context, controller, _) {
          final notes = controller.notes;

          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notes.isEmpty) {
            return const Center(child: Text('Nenhuma Nota'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder:
                  (context, index) => Card(
                    child: TileNoteWidget(
                      titleNote: notes[index].title,
                      textNote: notes[index].text,
                      indexNote: index,
                      editNote:
                          () => controller.editNote(index, notes[index].text),
                      deleteNote: () => controller.removeNote(index),
                    ),
                  ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => AddNoteDialog(),
            ),
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
