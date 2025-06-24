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

  Future<void> load() async {
    loading = true;
    notifyListeners();

    notes = await notesRepository.fetchAll();
    loading = false;
    notifyListeners();
  }

  /*Future<bool> save(String text) async {
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

  */
  Future<String?> save(String title) async {
    final noteId = FirebaseDatabase.instance.ref().child('notes').push().key;

    if (noteId == null) {
      debugPrint("Failed to generate Firebase key.");
      return null;
    }
    
    final note = Note(
      id: noteId,
      // FIX: Use the title from the dialog instead of a hardcoded string.
      title: title,
      // The note starts with no text and no images.
      lastEditedDateTime: DateTime.now(),
    );

    final success = await notesRepository.create(note);

    if (success) {
      notes.insert(0, note);
      notifyListeners();
      return noteId; // Return the ID on success
    }

    return null; // Return null on failure
  }

  Future<void> addPhotoToNote(String noteId, String photoPath) async {
    try {
      final noteToUpdate = notes.firstWhere((note) => note.id == noteId);
      
      // Create a new list containing all old paths plus the new one.
      final newImagePaths = List<String>.from(noteToUpdate.imagePaths)..add(photoPath);
      
      final updatedNote = noteToUpdate.copyWith(imagePaths: newImagePaths);

      final success = await notesRepository.update(updatedNote);

      if (success) {
        final index = notes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          notes[index] = updatedNote;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error adding photo to note: $e");
    }
  }


  /// FIX: Changed to take `noteId` instead of an index for reliability.
  Future<void> editNote(String noteId, String newText) async {
    final originalNote = notes.firstWhere((note) => note.id == noteId);
    final originalIndex = notes.indexOf(originalNote);

    final updatedNote = originalNote.copyWith(
      text: newText,
      lastEditedDateTime: DateTime.now(),
    );
    
    // Optimistic UI update
    notes[originalIndex] = updatedNote;
    notifyListeners();

    final success = await notesRepository.update(updatedNote);

    // If the update failed, roll back the change in the UI.
    if (!success) {
      notes[originalIndex] = originalNote;
      notifyListeners();
    }
  }

  /// FIX: Changed to take `noteId` instead of an index.
  Future<void> removeNote(String noteId) async {
    final noteToRemove = notes.firstWhere((note) => note.id == noteId);
    
    // Optimistic UI update
    notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
    
    final success = await notesRepository.delete(noteToRemove);

    // If the delete failed, add the note back to the UI.
    if (!success) {
      notes.add(noteToRemove);
      // You might want to sort the list again here if order matters.
      notifyListeners();
    }
  }

  Note findById(String id) {
    return notes.firstWhere((note) => note.id == id);
  }
}
