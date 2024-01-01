import 'dart:io';

import 'package:clinigram_app/features/admin_manage/admin_manage.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';

class CategoriesNotifier
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoriesNotifier(this._ref) : super(const AsyncData([]));
  final Ref _ref;
  getCategories() async {
    try {
      state = const AsyncLoading();
      final categories =
          await _ref.read(categoriesRepoProvider).getAllCategories();
      state = AsyncData(categories);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  addNewCategory(CategoryModel categoryModel, File image) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      final categoryImageUrl =
          await uploadFileToFirebase(image, categoriesAttatchmentsCollection);
      final category = await _ref
          .read(categoriesRepoProvider)
          .addCategory(categoryModel.copyWith(imageUrl: categoryImageUrl));
      state = AsyncData([category, ...state.value!]);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }

  updateCategory(CategoryModel categoryModel,
      {bool imageUpdated = false}) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      if (imageUpdated) {
        final categoryImageUrl = await uploadFileToFirebase(
            File(categoryModel.imageUrl), categoriesAttatchmentsCollection);
        categoryModel = categoryModel.copyWith(imageUrl: categoryImageUrl);
      }

      await _ref.read(categoriesRepoProvider).updateCategory(categoryModel);
      final List<CategoryModel> updatedCategoriesList = [
        for (final category in state.asData!.value)
          if (category.id == categoryModel.id) categoryModel else category
      ];
      state = AsyncData(updatedCategoriesList);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }

  addNewSubCategory(
      String mainCategoryId, CategoryModel subCategoryModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      final subCategory = await _ref
          .read(categoriesRepoProvider)
          .addSubCategory(mainCategoryId, subCategoryModel);
      state = AsyncData([
        for (var category in state.value!)
          if (category.id == mainCategoryId)
            category.copyWith(
                subCategories: [subCategory, ...category.subCategories])
          else
            category
      ]);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }

  updateSubCategory(
    CategoryModel subCategoryModel,
  ) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      late String mainCategoryId;
      for (var mainCategory in state.asData!.value) {
        if (mainCategory.subCategories
            .any((element) => element.id == subCategoryModel.id)) {
          mainCategoryId = mainCategory.id!;
          break;
        }
      }
      await _ref
          .read(categoriesRepoProvider)
          .updateSubCategory(mainCategoryId, subCategoryModel);
      state = AsyncData([
        for (var category in state.value!)
          if (category.id == mainCategoryId)
            category.copyWith(subCategories: [
              for (final subCategory in category.subCategories)
                if (subCategory.id == subCategoryModel.id)
                  subCategoryModel
                else
                  subCategory
            ])
          else
            category
      ]);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<List<CategoryModel>>>(
        (ref) {
  return CategoriesNotifier(ref);
});
