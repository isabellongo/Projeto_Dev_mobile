import 'dart:convert';

class Note {
  final String? id;
  final String title;
  final String text;
  final DateTime lastEditedDateTime;

  Note({
    this.id,
    required this.title,
    required this.text,
    required this.lastEditedDateTime,
  });

  Note copyWith({
    String? id,
    String? title,
    String? text,
    DateTime? lastEditedDateTime
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      lastEditedDateTime: lastEditedDateTime ?? this.lastEditedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'lastEditedDateTime': lastEditedDateTime.toString(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      lastEditedDateTime: DateTime.fromMillisecondsSinceEpoch(map['lastEditedDateTime']),
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

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.text == text &&
        other.lastEditedDateTime == lastEditedDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ text.hashCode ^ lastEditedDateTime.hashCode;
  }
}
