import 'package:intl/intl.dart';

class Note {
  int? id;
  String title;
  String content;
  DateTime creationDate;
  bool isCompleted;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    this.isCompleted = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'creationDate': creationDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      creationDate: DateTime.parse(map['creationDate']),
      isCompleted: map['isCompleted'] == 1
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(creationDate);
  }
}
