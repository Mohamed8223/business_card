
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_member_model.freezed.dart';
part 'chat_member_model.g.dart';

@freezed
class ChatMemberModel with _$ChatMemberModel {
  factory ChatMemberModel({
    required String id,
    required String accountType,
    required String fullnameAr,
    required String fullnameEn,
    required String fullnameHe,
    required String imageUrl,
  }) = _ChatMemberModel;

  factory ChatMemberModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberModelFromJson(json);
}
