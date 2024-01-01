import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/admin_manage/presentation/widgets/add_category_dialog.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../admin_manage.dart';

class CategoriesManageView extends ConsumerWidget {
  const CategoriesManageView({super.key});
  _listenToState(BuildContext context, WidgetRef ref) {
    ref.listen(requestResponseProvider, (_, state) {
      state.whenOrNull(
        sucess: (message, addtionalData) => context.showSnackbarSuccess(
            S.of(context).CategoriesManageView_successMessage),
        error: (message, addtionalData) => context.showSnackbarSuccess(
            S.of(context).CategoriesManageView_errorMessage),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToState(context, ref);
    final ctegoriesAsync = ref.watch(categoriesProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClinigramButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const CategoryAddDialog());
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30)),
                child: Text(
                  S.of(context).CategoriesManageView_addButton,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
          title: Text(S.of(context).CategoriesManageView_categoriesTitle),
        ),
        body: ctegoriesAsync.when(
            data: (categories) => categories.isEmpty
                ? Center(
                    child: Text(
                        S.of(context).CategoriesManageView_emptyCategoriesList),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) => ExpansionTile(
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CategoryAddDialog(
                                                categoryModel:
                                                    categories[index],
                                                isSubCategory: true,
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.add_box_sharp,
                                      color: secondryColor,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CategoryAddDialog(
                                                categoryModel:
                                                    categories[index],
                                                isEdit: true,
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: secondryColor,
                                    ))
                              ],
                            ),
                          ),
                          title: Text(
                            categories[index].getLocalizedName(ref),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 10,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: categories[index]
                                      .subCategories
                                      .map((subCategory) => ListTile(
                                            title: Text(
                                              subCategory.getLocalizedName(ref),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          CategoryAddDialog(
                                                            categoryModel:
                                                                subCategory,
                                                            isEdit: true,
                                                            isSubCategory: true,
                                                          ));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: secondryColor,
                                                )),
                                          ))
                                      .toList(),
                                ),
                              ),
                            )
                          ]),
                      itemCount: categories.length,
                    ),
                  ),
            error: (_, __) => CustomErrorWidget(onTap: () {
                  ref.read(categoriesProvider.notifier).getCategories();
                }),
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
