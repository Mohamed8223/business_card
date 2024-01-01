import 'package:clinigram_app/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/admin_manage/providers/categories_notifier.dart';

class DoctorSpecialistNotifier extends StateNotifier<List<CategoryModel>> {
  DoctorSpecialistNotifier() : super([]);

  bool initialized = false;

  initSate(List<CategoryModel> initList) {
    state = initList;
    initialized = true;
  }

  initSateIfNotInitialized(List<CategoryModel> initList) {
    if (!initialized) {
      initSate(initList);
    }
  }

  selectSpecialist(CategoryModel mainCategory, CategoryModel subCategory) {
    if (state.any((element) => element.id == mainCategory.id)) {
      state = [
        for (var categoryElement in state)
          if (categoryElement.id == mainCategory.id)
            categoryElement.copyWith(
                subCategories: [...categoryElement.subCategories, subCategory])
          else
            categoryElement
      ];
    } else {
      state = [
        ...state,
        mainCategory.copyWith(
          subCategories: [subCategory],
        ),
      ];
    }
  }

  void unselectSpecialist(
      CategoryModel mainCategory, CategoryModel subCategory) {
    final updatedState = [
      for (var categoryElement in state)
        if (categoryElement.id == mainCategory.id)
          categoryElement.copyWith(
            subCategories: [
              for (var subCategoryElement in categoryElement.subCategories)
                if (subCategoryElement.id != subCategory.id) subCategoryElement,
            ],
          )
        else
          categoryElement,
    ];

    state = updatedState
        .where((element) => element.subCategories.isNotEmpty)
        .toList();
  }

  List<CategoryModel> getSubcategoriesForMainCategory(
      CategoryModel mainCategory) {
    final mainCategoryExists =
        state.any((category) => category.id == mainCategory.id);
    if (mainCategoryExists) {
      for (var category in state) {
        if (category.id == mainCategory.id) {
          return category.subCategories;
        }
      }
    }
    return []; // Return an empty list if the main category is not found.
  }

  bool isSubCategoryInState(
    CategoryModel mainCategory,
    CategoryModel subCategory,
  ) {
    final mainCategoryExists =
        state.any((category) => category.id == mainCategory.id);

    if (mainCategoryExists) {
      for (var category in state) {
        if (category.subCategories.any((sub) => sub.id == subCategory.id)) {
          return true;
        }
      }
    }

    return false;
  }

  reset() {
    state = [];
  }
}

final doctorsSpecialistProvider =
    StateNotifierProvider<DoctorSpecialistNotifier, List<CategoryModel>>((ref) {
  return DoctorSpecialistNotifier();
});

final clinicSpecialistProvider =
    StateNotifierProvider<DoctorSpecialistNotifier, List<CategoryModel>>((ref) {
  return DoctorSpecialistNotifier();
});

class FilteredSpecialiststNotifier extends StateNotifier<List<CategoryModel>> {
  FilteredSpecialiststNotifier(this._ref) : super([]);
  final Ref _ref;
  List<CategoryModel> _tempState = [];

  initState(DoctorJob doctorJob) {
    final categoriesList = _ref.read(categoriesProvider).value!;

    if (doctorJob == DoctorJob.dentist) {
      state = [categoriesList[0]];
    } else if (doctorJob == DoctorJob.beauty) {
      state = [categoriesList[1]];
    } else {
      state = categoriesList;
    }

    // sort
    final sortedCategories = state.map((category) {
      final subCategories = [...category.subCategories];
      subCategories.sort((a, b) {
        if (a.categoryType == CategoryType.specialist) {
          return -1;
        } else if (b.categoryType == CategoryType.specialist) {
          return 1;
        } else {
          return 0;
        }
      });
      return category.copyWith(subCategories: subCategories);
    }).toList();

    state = sortedCategories;
//
    _tempState = state;
  }

  initStateForClinic(ClinicJob job) {
    final categoriesList = _ref.read(categoriesProvider).value!;

    if (job == ClinicJob.dentist) {
      state = [categoriesList[0]];
    } else if (job == ClinicJob.beauty) {
      state = [categoriesList[1]];
    } else {
      state = categoriesList;
    }

    // sort
    final sortedCategories = state.map((category) {
      final subCategories = [...category.subCategories];
      subCategories.sort((a, b) {
        if (a.categoryType == CategoryType.specialist) {
          return -1;
        } else if (b.categoryType == CategoryType.specialist) {
          return 1;
        } else {
          return 0;
        }
      });
      return category.copyWith(subCategories: subCategories);
    }).toList();

    state = sortedCategories;
//
    _tempState = state;
  }

  onSpecialistStatusChanged(CategoryType categoryType, String specialistId) {
    _ref.read(doctorsSpecialistProvider.notifier).reset();
    state = _tempState;
    if (categoryType != CategoryType.specialist) {
      state = [
        for (var specialist in state)
          if (specialist.id == specialistId)
            specialist.copyWith(subCategories: [
              for (var subCategory in specialist.subCategories)
                if (subCategory.categoryType == categoryType) subCategory
            ])
          else
            specialist
      ];
    }
  }
}

final filteredDoctorSpecialistsProvider =
    StateNotifierProvider<FilteredSpecialiststNotifier, List<CategoryModel>>(
        (ref) {
  return FilteredSpecialiststNotifier(ref);
});

final filteredClinicSpecialistsProvider =
    StateNotifierProvider<FilteredSpecialiststNotifier, List<CategoryModel>>(
        (ref) {
  return FilteredSpecialiststNotifier(ref);
});
