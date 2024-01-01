import 'package:clinigram_app/features/search/search.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../admin_manage/admin_manage.dart';
import '../../../admin_manage/data/models/category_model.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({
    super.key,
    this.mainCategory,
    this.subCategory,
    this.layoutType = CategorySectionLayout.vertical,
  });
  final CategoryModel? mainCategory;
  final CategoryModel? subCategory;
  final CategorySectionLayout layoutType;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection> {
  late List<CategoryModel> mainCategoriesList;

  @override
  void initState() {
    super.initState();
    mainCategoriesList = ref
        .read(categoriesProvider)
        .asData!
        .value
        .where((element) => element.visible)
        .toList();
    if (widget.mainCategory != null) {
      Future.delayed(Duration.zero, () {
        ref.read(selectedMainCategoryProvider.notifier).update((state) {
          if (widget.mainCategory != null &&
              mainCategoriesList
                  .any((element) => element.id == widget.mainCategory!.id)) {
            ref
                .read(selectedSubCategoryProvider.notifier)
                .update((state) => widget.subCategory);
            return mainCategoriesList
                .firstWhere((element) => element.id == widget.mainCategory!.id);
          } else {
            return mainCategoriesList.first;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMainCategory = ref.watch(selectedMainCategoryProvider);
    return widget.layoutType == CategorySectionLayout.vertical
        ? Column(
            children: [
              CategoryDropDown(
                value: selectedMainCategory,
                hintText: S.of(context).CategorySection_Select_Main_Category,
                items: mainCategoriesList,
                onChanged: (mainCategory) {
                  ref
                      .read(selectedMainCategoryProvider.notifier)
                      .update((state) => mainCategory);
                  ref
                      .read(selectedSubCategoryProvider.notifier)
                      .update((state) => mainCategory?.subCategories.first);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer(builder: (context, ref, child) {
                final selectedSubCategory =
                    ref.watch(selectedSubCategoryProvider);
                return CategoryDropDown(
                  value: selectedSubCategory ??
                      selectedMainCategory?.subCategories.first,
                  hintText: selectedMainCategory == null
                      ? S
                          .of(context)
                          .CategorySection_First_select_a_main_category
                      : S.of(context).SelectCategorySection_Specialization,
                  items: selectedMainCategory?.subCategories ?? [],
                  onChanged: (subCategory) {},
                );
              }),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: CategoryDropDown(
                  value: selectedMainCategory,
                  hintText: S.of(context).CategorySection_Select_Main_Category,
                  items: mainCategoriesList,
                  onChanged: (mainCategory) {
                    ref
                        .read(selectedMainCategoryProvider.notifier)
                        .update((state) => mainCategory);
                    ref
                        .read(selectedSubCategoryProvider.notifier)
                        .update((state) => mainCategory?.subCategories.first);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final selectedSubCategory =
                      ref.watch(selectedSubCategoryProvider);
                  return CategoryDropDown(
                    value: selectedSubCategory ??
                        (selectedMainCategory?.subCategories.isNotEmpty == true
                            ? selectedMainCategory?.subCategories.first
                            : null),
                    hintText: selectedMainCategory == null
                        ? S
                            .of(context)
                            .CategorySection_First_select_a_main_category
                        : S.of(context).SelectCategorySection_Specialization,
                    items: selectedMainCategory?.subCategories ?? [],
                    onChanged: (subCategory) {},
                  );
                }),
              ),
            ],
          );
  }
}

class CategoryDropDown extends StatelessWidget with ValidationMixin {
  final List<CategoryModel> items;
  final CategoryModel? value;
  final void Function(CategoryModel?)? onChanged;
  final String hintText;
  const CategoryDropDown({
    Key? key,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: nameAr
    return DropdownButtonFormField<CategoryModel>(
      validator: (value) => emptyValidation(value?.nameAr, context),
      decoration: InputDecoration(
        hintText: hintText,
      ),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item.nameAr,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      value: value,
      onChanged: onChanged,
    );
  }
}
