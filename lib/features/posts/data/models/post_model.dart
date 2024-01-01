import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/geo_location_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const PostModel._();
  factory PostModel({
    String? id,
    required UserModel userModel,
    required List<String> attatchments,
    @Default('') String description,
    @Default(0) int commentsCount,
    @Default([]) List<UserModel> likes,
    required DateTime createdAt,
    @Default('') String cityId, // doctor city
    required CategoryModel mainCategory, // doctor main category
    required CategoryModel subCategory,
    @GeoPointConverter() GeoPoint? postLocation,
    // doctor sub category
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toDocument(DocumentReference userRefrence) => toJson()
    ..remove('id')
    ..update(
      'user_model',
      (value) => userRefrence,
    );
}
