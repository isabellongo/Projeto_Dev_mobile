import 'package:flutter/material.dart';
import './note_widget.dart';
import './add_note_dialog.dart';

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
        icon: const Icon(Icons.edit),
        onPressed: () => {
          openDialog(context),
        },
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

  Future openDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:  Text(
                    'Editar arquivo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          content: TextField(
            autofocus:true,
            decoration: InputDecoration(hintText: ('Digite o nome'))
          ),
          actions: [
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () => submit(context),
           )
         ],
        )
      );

  void submit(BuildContext context){
   // Navigator.of(context).pop()
  }
  
}



