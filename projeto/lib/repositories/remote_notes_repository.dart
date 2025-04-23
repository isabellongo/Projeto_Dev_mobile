import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/note.dart';
import 'notes_repository.dart';

class RemoteNotesRepository extends NotesRepository {
  @override
  Future<List<Note>> fetchAll() async {
    final response = await http.get(Uri.parse('https://url.example.com/api/notes'));

    final List<Note> notes = [];

    if (response.statusCode == 200) {
      final notesMap = jsonDecode(response.body) as List;

      for (var note in notesMap) {
        notes.add(Note(
          id: note['id'] as String,
          title: note['title'] as String,
          text: note['text'] as String,
          lastEditedDateTime: DateTime.now(),
        ));
      }
    }
    return notes;
  }

  @override
  Future<bool> create(Note note) async {
    final response = await http.post(
      Uri.parse('https://url.example.com/api/notes'),
      body: note.toMap(),
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> update(Note note) async {
    final response = await http.put(
      Uri.parse('https://url.example.com/api/notes/${note.id}'),
      body: note.toMap(),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> delete(Note note) async {
    final response = await http.delete(
      Uri.parse('https://url.example.com/api/notes/${note.id}'),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
