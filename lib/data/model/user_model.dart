// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;
  final int remainingUpdates;
  final int remainingDeletes;
  final int taskStrikes;

  UserModel({
    required this.name,
    required this.id,
    required this.email,
    required this.remainingUpdates,
    required this.remainingDeletes,
    required this.taskStrikes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'email': email,
      'remainingUpdates': remainingUpdates,
      'remainingDeletes': remainingDeletes,
      'taskStrikes': taskStrikes,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      remainingUpdates: map['remainingUpdates'] as int,
      remainingDeletes: map['remainingDeletes'] as int,
      id: map['id'] as int,
      taskStrikes: map['taskStrikes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, remainingUpdates: $remainingUpdates, remainingDeletes: $remainingDeletes, taskStrikes: $taskStrikes)';
  }
}
