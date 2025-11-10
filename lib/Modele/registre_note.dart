import 'package:intl/intl.dart';

class Note {
  int? id;
  String title;
  String content;
  DateTime creationDate;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(creationDate);
  }
}