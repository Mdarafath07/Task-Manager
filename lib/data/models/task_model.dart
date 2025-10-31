import 'package:flutter/foundation.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String email;
  final String createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> jsonData) {
    return TaskModel(
      id: jsonData['_id'],
      title: jsonData['title'],
      description: jsonData['description'],
      status: jsonData['status'],
      email: jsonData['email'],
      createdDate: jsonData['createdDate'],
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? email,
    String? createdDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      email: email ?? this.email,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          status == other.status &&
          email == other.email &&
          createdDate == other.createdDate;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode ^ status.hashCode ^ email.hashCode ^ createdDate.hashCode;
}