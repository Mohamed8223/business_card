import 'package:clinigram_app/features/chats/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  factory ChatModel({
    required String id,
    required MessageModel? lastMessage,
    required List<ChatMemberModel> members,
    @Default(0) int unreadCount,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  factory ChatModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatModel.fromJson(data).copyWith(id: doc.id);
  }
}
