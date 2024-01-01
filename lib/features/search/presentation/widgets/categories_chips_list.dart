import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../admin_manage/admin_manage.dart';
import '../../search.dart';

class CategoriesChipsList extends ConsumerWidget {
  const CategoriesChipsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesList = ref.read(categoriesProvider).asData?.value;
    final selectedMainCategory = ref.watch(selectedMainCategoryProvider);
    final selectedSubCategory = ref.watch(selectedSubCategoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            S.of(context).CategoriesChipsList_Specialisation,
            style: const TextStyle(
                color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: categoriesList
                  ?.where((element) => element.visible)
                  .map((e) => GestureDetector(
                        onTap: () => {
                          ref
                              .read(selectedMainCategoryProvider.notifier)
                              .update((state) => e),
                          ref
                              .read(selectedSubCategoryProvider.notifier)
                              .update((state) => null)
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: selectedMainCategory == e
                                    ? primaryColor
                                    : const Color(0XFFD9D9D9),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              e.getLocalizedName(ref),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: selectedMainCategory == e
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ))
                  .toList() ??
              [],
        ),
        if (selectedMainCategory != null) ...[
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              S.of(context).CategoriesChipsList_Your_Interests,
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: selectedMainCategory.subCategories
                .map((e) => GestureDetector(
                      onTap: () => {
                        ref
                            .read(selectedSubCategoryProvider.notifier)
                            .update((state) => e)
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: selectedSubCategory == e
                                  ? primaryColor
                                  : const Color(0XFFD9D9D9),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            e.getLocalizedName(ref),
                            style: TextStyle(
                                fontSize: 17,
                                color: selectedSubCategory == e
                                    ? Colors.white
                                    : Colors.black),
                          )),
                    ))
                .toList(),
          ),
        ]
      ],
    );
  }
}
