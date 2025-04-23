import '../models/note.dart';
import 'package:hive/hive.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read(),
      title: reader.read(),
      text: reader.read(),
      lastEditedDateTime: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.text);
    writer.write(obj.lastEditedDateTime);
  }
}
