import '../models/note.dart';
import 'notes_repository.dart';

class MemoryNotesRepository extends NotesRepository {
  final _notes = <Note>[];

  @override
  Future<bool> create(Note note) async {
    _notes.add(note);
    return Future.value(true);
  }

  @override
  Future<bool> delete(Note note) {
    _notes.remove(note);
    return Future.value(true);
  }

  @override
  Future<List<Note>> fetchAll() async {
    return Future.value(_notes);
  }

  @override
  Future<bool> update(Note note) {
    return Future.value(true);
  }
}
