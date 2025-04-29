import 'package:flutter/material.dart';

abstract class NoteWidget extends StatelessWidget {
  final String titleNote;
  final String textNote;
  final int indexNote;
  final Function() editNote;
  final Future<void> Function() deleteNote;

  const NoteWidget({
    super.key,
    required this.titleNote,
    required this.textNote,
    required this.indexNote,
    required this.editNote,
    required this.deleteNote,
  });

  @override
  Widget build(BuildContext context);
}
