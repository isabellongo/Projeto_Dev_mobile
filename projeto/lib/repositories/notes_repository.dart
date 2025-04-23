import '../models/note.dart';

abstract class NotesRepository {
  Future<List<Note>> fetchAll();
  Future<bool> create(Note note);
  Future<bool> update(Note note);
  Future<bool> delete(Note note);
}
