import 'package:flutter/material.dart';
import '../widgets/tile_note_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/add_note_dialog.dart';
import '../controllers/notes_controller.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
      ),
      body: Consumer<NotesController>(builder: (context, controller, _) {
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
            itemBuilder: (context, index) => Card(
              child: TileNoteWidget(
                titleNote: notes[index].title,
                textNote: notes[index].text,
                editNote: () => controller.editNote(index),
                deleteNote: () => controller.removeNote(index),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
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
