import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/core.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();
  const factory NotificationModel({
    @Default('')
    @JsonKey(includeToJson: false, includeFromJson: false)
    String id,
    required String title,
    required String body,
    required String type,
    required String senderId,
    required String senderAvatar,
    required String recieverId,
    @JsonKey(
      name: 'created_at',
      fromJson: timestampToDate,
      toJson: dateTimeToTimestamp,
    )
    required DateTime createdAt,
  }) = _NotificationModel;
  factory NotificationModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return NotificationModel.fromJson(data).copyWith(id: doc.id);
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toDocument() => toJson();
}
