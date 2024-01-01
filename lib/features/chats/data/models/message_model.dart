import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/core.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  factory MessageModel({
    String? id,
    required String senderId,
    required String content,
    required ChatMessageType messageType,
    required DateTime timestamp,
    @Default(false) bool isRead,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isMyMessgae,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  factory MessageModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MessageModel.fromJson(data).copyWith(
        id: doc.id, messageType: stringToChatMessageType(data['message_type']));
  }
}
