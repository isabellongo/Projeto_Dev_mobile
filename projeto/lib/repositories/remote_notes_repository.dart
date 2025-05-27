import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note.dart';
import 'notes_repository.dart';




class RemoteNotesRepository extends NotesRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference get _userNotesRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null){
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Nenhum usuário logado.',
        );
    }
    return _db.child('notes').child(uid);
  }

  @override
  Future<List<Note>> fetchAll() async {
    final snapshot = await _userNotesRef.get();

    final List<Note> notes = [];

    if (snapshot.exists) { 
      final rawData = snapshot.value as Map<dynamic, dynamic>;
      final data = rawData.map((key, value) => MapEntry(key.toString(), value));

      data.forEach((key, value){
        if(value is Map){
        notes.add(Note.fromMap(Map<String, dynamic>.from(value)));
        }
      });
    }return notes;
  }

  @override
  Future<bool> create(Note note) async {
    try {
      await _userNotesRef.child(note.id).set(note.toMap());
      return true;
    } catch (e) {
      print('Erro na criação da nota: $e');
      return false;
    }
    
  }

  @override
  Future<bool> update(Note note) async {
    try {
      await _userNotesRef.child(note.id).update(note.toMap());
      return true;
    } catch (e) {
      print('Erro alterando nota: $e');
      return false;
    }
  }

  @override
  Future<bool> delete(Note note) async {
    try {
      await _userNotesRef.child(note.id).remove();
      return true;
    } catch (e) {
      print('Erro na deleção da nota: $e');
      return false;
    }
  }

  Future logOut() async{
    await FirebaseAuth.instance.signOut();
  }
}
