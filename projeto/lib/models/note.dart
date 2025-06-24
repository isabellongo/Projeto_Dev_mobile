import 'dart:convert';

class Note {
  final String id;
  final String title;
  String? text;
  final DateTime lastEditedDateTime;
  final List<String> imagePaths;

  Note({
    required this.id,
    required this.title,
    this.text,
    required this.lastEditedDateTime,
    List<String>? imagePaths,
  }) : imagePaths = imagePaths ?? [];

  Note copyWith({
    String? id,
    String? title,
    String? text,
    DateTime? lastEditedDateTime,
    List<String>? imagePaths,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      lastEditedDateTime: lastEditedDateTime ?? this.lastEditedDateTime,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'lastEditedDateTime': lastEditedDateTime.toIso8601String(),
      // --- FIX 1: Use the plural key 'imagePaths' when saving ---
      if (imagePaths.isNotEmpty) 'imagePaths': imagePaths,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      // FIX 2: Allow text to be null if it's missing from the map
      text: map['text'],
      lastEditedDateTime: DateTime.parse(map['lastEditedDateTime']),
      // --- FIX 3: Check for and read from the same plural key 'imagePaths' ---
      imagePaths: map['imagePaths'] != null
          ? List<String>.from(map['imagePaths'])
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note {\nId: $id, \nTitle: $title, \nText: $text, \nLast Edited: $lastEditedDateTime\n}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode {
    // A better hashcode implementation for consistency
    return id.hashCode;
  }
}
