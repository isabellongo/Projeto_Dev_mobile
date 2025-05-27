import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../repositories/notes_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

class NotesController extends ChangeNotifier {
  final NotesRepository notesRepository;
  List<Note> notes = [];
  bool loading = true;
  StreamSubscription<User?>? _authSub;

  NotesController(this.notesRepository) {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        load();
      } else {
        notes = [];
        notifyListeners();
      }
    });
  }

  Future<List<Note>> load() async {
    loading = true;
    notifyListeners();

    notes = await notesRepository.fetchAll();
    loading = false;
    notifyListeners();

    return notes;
  }

  Future<bool> save(String text) async {
    final noteId =
        FirebaseDatabase.instance.ref().push().key ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final note = Note(
      id: noteId,
      title: 'Escaneado em ${DateTime.now()}',
      text: text,
      lastEditedDateTime: DateTime.now(),
    );

    final success = await notesRepository.create(note);

    if (success) {
      notes = await notesRepository.fetchAll();
      notifyListeners();
      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<void> editNote(int index, String newText) async {
    final note = notes[index].copyWith(
      title: notes[index].title,
      text: newText,
    );
    notes.replaceRange(index, index + 1, [note]);

    notifyListeners();

    final success = await notesRepository.update(note);

    if (!success) {
      final note = notes[index].copyWith(
        title: notes[index].title,
        text: notes[index].text,
      );
      notes.replaceRange(index, index + 1, [note]);
      notifyListeners();
    }
  }

  Future<void> removeNote(int index) async {
    final note = notes[index];

    final success = await notesRepository.delete(note);

    if (success) {
      notes.remove(note);
    }
    notifyListeners();
  }

  Note findById(String id) {
    return notes.firstWhere((note) => note.id == id);
  }
}
