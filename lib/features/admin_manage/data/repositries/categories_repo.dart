import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoriesRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<CategoryModel> addCategory(CategoryModel categoryModel) async {
    final docRef = await _firebaseFirestore
        .collection(categoriesCollection)
        .add(categoryModel.toDocument(exculdeImade: false));
    return categoryModel.copyWith(id: docRef.id);
  }

  Future<CategoryModel> updateCategory(CategoryModel categoryModel) async {
    await _firebaseFirestore
        .collection(categoriesCollection)
        .doc(categoryModel.id)
        .update(categoryModel.toDocument(exculdeImade: false));
    return categoryModel;
  }

  Future<CategoryModel> addSubCategory(
      String mainCategoryId, CategoryModel categoryModel) async {
    final docRef = await _firebaseFirestore
        .collection(categoriesCollection)
        .doc(mainCategoryId)
        .collection(subCategoriesCollection)
        .add(categoryModel.toDocument());
    return categoryModel.copyWith(id: docRef.id);
  }

  Future<CategoryModel> updateSubCategory(
      String parentCategoryId, CategoryModel subCategoryModel) async {
    await _firebaseFirestore
        .collection(categoriesCollection)
        .doc(parentCategoryId)
        .collection(subCategoriesCollection)
        .doc(subCategoryModel.id)
        .update(subCategoryModel.toDocument(exculdeImade: false));
    return subCategoryModel;
  }

  Future<List<CategoryModel>> getAllCategories({bool activeOlny = true}) async {
    final List<CategoryModel> categoriesList = [];

    final categoriesSnapshots =
        await _firebaseFirestore.collection(categoriesCollection).get();

    for (var categoryMap in categoriesSnapshots.docs) {
      final List<CategoryModel> subCategoriesList = [];

      final categoryModel = CategoryModel.fromDocument(categoryMap);

      final subCategoriesSnapshots = await _firebaseFirestore
          .collection(categoriesCollection)
          .doc(categoryModel.id)
          .collection(subCategoriesCollection)
          .get();
      for (var subCategoryMap in subCategoriesSnapshots.docs) {
        final subCategoryModel = CategoryModel.fromDocument(subCategoryMap);

        subCategoriesList.add(subCategoryModel);
      }
      categoriesList
          .add(categoryModel.copyWith(subCategories: subCategoriesList));
    }
    return categoriesList;
  }
}

final categoriesRepoProvider = Provider<CategoriesRepo>((ref) {
  return CategoriesRepo();
});
