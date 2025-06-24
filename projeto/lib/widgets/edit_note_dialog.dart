import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notes_controller.dart';

class EditNoteDialog extends StatefulWidget{
  final String noteId;
  final String currentText;

  const EditNoteDialog({
    super.key,
    required this.noteId,
    required this.currentText,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();

}

class _EditNoteDialogState extends State<EditNoteDialog>{
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;

  @override
  void initState(){
    super.initState();
    _textController = TextEditingController(text: widget.currentText);
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final controller = context.read<NotesController>();

    return AlertDialog(
      title:  Text(
        'Editar arquivo',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Digite o título'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Informe o título!";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await controller.editNote(widget.noteId,_textController.text);
              if (context.mounted){
               Navigator.of(context).pop();
               ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Título atualizado.')),
            );
              }
            }
          },
        )
      ],
    );
    
  }
}
 
