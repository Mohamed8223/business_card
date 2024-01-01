import 'package:clinigram_app/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  factory CategoryModel({
    String? id,
    required String nameAr,
    required String nameEn,
    required String nameHe,
    @Default('') String imageUrl,
    @Default(false) bool visible,
    @Default(CategoryType.specialist) CategoryType categoryType,
    // ignore: invalid_annotation_target
    @Default([]) List<CategoryModel> subCategories,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  factory CategoryModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CategoryModel.fromJson(data).copyWith(id: doc.id);
  }
  Map<String, dynamic> toDocument({bool exculdeImade = true}) {
    final jsonData = toJson()
      ..remove('id')
      ..remove('sub_categories');
    if (exculdeImade) {
      jsonData.remove('image_url');
    }
    return jsonData;
  }
}
