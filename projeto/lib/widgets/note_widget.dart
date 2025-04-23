import 'package:flutter/material.dart';

abstract class NoteWidget extends StatelessWidget {
  final String titleNote;
  final String textNote;
  final Function() editNote;
  final void Function() deleteNote;

  const NoteWidget({
    super.key,
    required this.titleNote,
    required this.textNote,
    required this.editNote,
    required this.deleteNote,
  });

  @override
  Widget build(BuildContext context);
}
