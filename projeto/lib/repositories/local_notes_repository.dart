import '../adapters/note_hive_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';
import 'notes_repository.dart';

class LocalNotesRepository extends NotesRepository {
  late Box<Note> box;

  LocalNotesRepository() {
    initHive();
  }

  initHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }
  }

  openLocalDatabase() async {
    await initHive();
    box = await Hive.openBox<Note>('notesRepo');
  }

  @override
  Future<bool> create(Note note) async {
    if (!box.isOpen) await openLocalDatabase();

    box.put(note.id, note);
    return Future.value(true);
  }

  @override
  Future<bool> delete(Note note) async {
    if (!box.isOpen) await openLocalDatabase();

    box.delete(note.id);
    return Future.value(true);
  }

  @override
  Future<List<Note>> fetchAll() async {
    await openLocalDatabase();
    return Future.value(box.values.toList());
  }

  @override
  Future<bool> update(Note note) async {
    if (!box.isOpen) await openLocalDatabase();

    box.put(note.id, note);
    return Future.value(true);
  }
}
