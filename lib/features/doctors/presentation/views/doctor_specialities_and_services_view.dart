import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../admin_manage/data/models/category_model.dart';
import '../../providers/providers.dart';

class DoctorSpecialitiesAndServicesView extends ConsumerWidget {
  final StateNotifierProvider<DoctorSpecialistNotifier, List<CategoryModel>>
      specialistProvider;

  final CategoryType categoryType;

  final StateNotifierProvider<FilteredSpecialiststNotifier, List<CategoryModel>>
      filteredSpecialistProvider;

  const DoctorSpecialitiesAndServicesView(
      {super.key,
      required this.specialistProvider,
      required this.filteredSpecialistProvider,
      required this.categoryType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSpecialistsList = ref.watch(filteredSpecialistProvider);
    ref.watch(specialistProvider);

    var title = categoryType == CategoryType.specialist
        ? S.of(context).DoctorInfoStepper_Specializations
        : S.of(context).DoctorInfoStepper_Services;

    var tooltip = "";
    if (categoryType == CategoryType.specialist) {
      tooltip =
          "هل أنت طبيب صحاب تخصص مع شهادة في احدى الجامعات المعترف بها؟ اختر التخصصات من القائمة.";
    }

    // Check if there are any categories with subcategories after filtering
    bool hasFilteredCategories = filteredSpecialistsList.any((category) =>
        filterCategoryByType(categoryType, category.subCategories).isNotEmpty);

    if (!hasFilteredCategories) {
      // Return an empty SizedBox or any other widget to indicate nothing to show
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (tooltip.isNotEmpty) ...[
          const SizedBox(
            width: 12,
          ),
          Text(
            tooltip,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          )
        ],
        const SizedBox(
          height: 16,
        ),
        filteredSpecialistsList.isEmpty
            ? Text(
                S.of(context).Select_clinic_type_to_show_relevant_specialities)
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Filter subcategories for the current category
                  final filteredSubCategories = filterCategoryByType(
                      categoryType,
                      filteredSpecialistsList[index].subCategories);

                  // If there are no filtered subcategories, don't display the title and the related UI
                  if (filteredSubCategories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filteredSpecialistsList[index]
                                .getLocalizedName(ref),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        runSpacing: 8,
                        spacing: 8,
                        children: filteredSubCategories.map((subCategory) {
                          final category = filteredSpecialistsList[index];
                          final isSubCategorySelected = ref
                              .read(specialistProvider.notifier)
                              .isSubCategoryInState(category, subCategory);

                          return GestureDetector(
                            onTap: () {
                              toggleSelection(category, subCategory, ref,
                                  selected: isSubCategorySelected);
                            },
                            child: Chip(
                              backgroundColor: isSubCategorySelected
                                  ? primaryColor
                                  : Colors.grey.withOpacity(0.75),
                              label: Text(
                                subCategory.getLocalizedName(ref),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                itemCount: filteredSpecialistsList.length,
              ),
      ],
    );
  }

  void toggleSelection(
      CategoryModel mainCategory, CategoryModel subCategory, WidgetRef ref,
      {bool selected = false}) {
    selected
        ? ref
            .read(specialistProvider.notifier)
            .unselectSpecialist(mainCategory, subCategory)
        : ref
            .read(specialistProvider.notifier)
            .selectSpecialist(mainCategory, subCategory);
  }
}
