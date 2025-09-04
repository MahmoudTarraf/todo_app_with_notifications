import 'dart:convert';

class AchievementsModel {
  final int id;
  final String title;
  final String? subTitle;
  final int condition;
  final bool isCompleted;
  final String? achievedAt;
  final int progress;

  AchievementsModel({
    required this.id,
    required this.title,
    this.subTitle,
    required this.condition,
    required this.isCompleted,
    required this.progress,
    this.achievedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'condition': condition,
      'isCompleted': isCompleted,
      'achievedAt': achievedAt,
      'progress': progress,
    };
  }

  factory AchievementsModel.fromMap(Map<String, dynamic> map) {
    return AchievementsModel(
      id: map['id'] as int,
      title: map['title'] as String,
      subTitle: map['subTitle'] as String?,
      condition: map['condition'] as int,
      isCompleted: map['isCompleted'] == true || map['isCompleted'] == 1,
      achievedAt: map['achievedAt'] ?? "",
      progress: map['progress'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AchievementsModel.fromJson(String source) =>
      AchievementsModel.fromMap(json.decode(source));
}
