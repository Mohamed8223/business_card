import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../profile/profile.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const CommentModel._();
  factory CommentModel({
    String? id,
    required String commentText,
    required UserModel user,
    required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toDocument(DocumentReference userRefrence) => toJson()
    ..remove('id')
    ..update(
      'user',
      (value) => userRefrence,
    );
}

@freezed
class CommentModelState with _$CommentModelState {
  const CommentModelState._();
  const factory CommentModelState({
    required List<CommentModel> comments,
    @Default('') String error,
    @Default(true) bool isLoading,
  }) = _CommentModelState;
  factory CommentModelState.init() => const CommentModelState(comments: []);
  bool get hasError => error.isNotEmpty;
  factory CommentModelState.fromJson(Map<String, dynamic> json) =>
      _$CommentModelStateFromJson(json);
}
