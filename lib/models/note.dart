import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }

  static Note fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
