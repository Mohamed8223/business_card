import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/search/presentation/views/custom_search_view_v2.dart';
import 'package:clinigram_app/features/search/providers/location_provider.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../admin_manage/admin_manage.dart';
import '../../../search/search.dart';

class CategoriesHomeList extends ConsumerStatefulWidget {
  const CategoriesHomeList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesHomeListState();
}

class _CategoriesHomeListState extends ConsumerState<CategoriesHomeList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (ref.read(categoriesProvider).value!.isEmpty) {
        ref.read(categoriesProvider.notifier).getCategories();
      }
      if (ref.read(citiesProvider).value!.isEmpty) {
        ref.read(citiesProvider.notifier).getCities();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesList = ref.watch(categoriesProvider);

    var staticCategories = [
      CategoryCardItem(
        image: mapImage,
        title: S.of(context).Nearby_Clinics,
        isLocalImage: true,
      ),
      CategoryCardItem(
        image: helpImage,
        title: S.of(context).Urgent,
        isLocalImage: true,
      ),
    ];

    return categoriesList.when(
        data: (categories) => ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              // Check if the index is for dynamic items or static items
              if (index < categories.length) {
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(selectedMainCategoryProvider.notifier)
                        .update((state) => categories[index]);

                    if (FeatureSwitches.searchV2 == false) {
                      ref
                          .read(selectedCityProvider.notifier)
                          .update((state) => null);
                    }

                    Future.delayed(Duration.zero, () {
                      ref.read(selectedDistanceProvider.notifier).change(null);
                      context.push(const CustomSearchResultsView());
                      ref
                          .read(customSearchProvider.notifier)
                          .performCustomSearch();
                    });
                  },
                  child: CategoryCardItem(
                    image: categories[index].imageUrl,
                    title: categories[index].getLocalizedName(ref),
                    isLocalImage: false,
                  ),
                );
              } else {
                // Handle the static items
                return GestureDetector(
                  onTap: () {
                    if (index == categories.length) {
                      ref.read(selectedDistanceProvider.notifier).change(15);
                      ref.read(locationProvider.notifier).getLocation();
                      Future.delayed(Duration.zero, () {
                        context.push( CustomSearchViewV2());
                        ref
                            .read(customSearchProvider.notifier)
                            .performCustomSearch();
                      });

                    } else if (index == categories.length + 1) {
                      ref.read(selectedDistanceProvider.notifier).change(null);
                      // [Your click handling code here]
                    }
                  },
                  child: staticCategories[index - categories.length],
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 15,
            ),
            itemCount: categories.length + staticCategories.length),
        error: (_, __) => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

class CategoryCardItem extends StatelessWidget {
  const CategoryCardItem(
      {super.key,
        required this.image,
        required this.title,
        required this.isLocalImage});
  final String image;
  final String title;
  final bool isLocalImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
        ),
        color: primaryColor,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: isLocalImage
                ? Image.asset(image)
                : CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
