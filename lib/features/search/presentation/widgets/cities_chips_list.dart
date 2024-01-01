import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../admin_manage/admin_manage.dart';
import '../../search.dart';

class CitiesChipsList extends ConsumerWidget {
  const CitiesChipsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesList = ref.read(citiesProvider).asData!.value;
    final selectedCity = ref.watch(selectedCityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (FeatureSwitches.searchV2 == false) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              S.of(context).CitiesChipsList_Region,
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: citiesList
              .where((element) => element.visible)
              .map((e) => GestureDetector(
                    onTap: () => ref
                        .read(selectedCityProvider.notifier)
                        .update((state) => e),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: selectedCity == e
                                ? primaryColor
                                : const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          e.getLocalizedName(ref),
                          style: TextStyle(
                              fontSize: 17,
                              color: selectedCity == e
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
