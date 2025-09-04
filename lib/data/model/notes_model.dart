import '../../core/const_data/app_strings.dart';

class NotesModel {
  int? id;
  String title;
  String content;

  NotesModel({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return {
      AppStrings.notesIdColumnName: id,
      AppStrings.notesTitleColumnName: title,
      AppStrings.notesContentColumnName: content,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map[AppStrings.notesIdColumnName],
      title: map[AppStrings.notesTitleColumnName],
      content: map[AppStrings.notesContentColumnName],
    );
  }
}
