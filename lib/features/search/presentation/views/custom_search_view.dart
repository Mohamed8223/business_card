import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../search.dart';

class CustomSearchView extends ConsumerWidget {
  const CustomSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).CustomSearchView_Custom_Search),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const CitiesChipsList(),
                const SizedBox(height: 20),
                const CategoriesChipsList(),
                const SizedBox(
                  height: 50,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final citySelected =
                        ref.watch(selectedCityProvider) != null;
                    final mainCategorySelected =
                        ref.watch(selectedMainCategoryProvider) != null;
                    return ClinigramButton(
                      enabled: mainCategorySelected || citySelected,
                      onPressed: () {
                        ref
                            .read(customSearchProvider.notifier)
                            .performCustomSearch();
                        context.push(const CustomSearchResultsView());
                      },
                      child: Text(
                        S.of(context).CustomSearchView_Search,
                        style: context.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
