import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/notes_controller.dart';

class AddNoteDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  AddNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<NotesController>();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 300,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nova Nota',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 6),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      label: const Text('Titulo'),
                    ),
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) return "Informe o título!";

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton.tonalIcon(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final String? newNoteId = await controller.save(_titleController.text);
                          if (context.mounted) {
                            context.go('/camera/$newNoteId');
                          }
                        } else {
                          print('FALHA NO SAVE');
                        }
                      },
                      label: const Text('Salvar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
