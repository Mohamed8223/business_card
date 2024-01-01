import 'package:clinigram_app/core/constants/constants.dart';
import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/search/presentation/views/custom_search_view.dart';
import 'package:clinigram_app/features/search/presentation/views/custom_search_view_v2.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/search/providers/search_state_providers.dart';

class SearchBox extends ConsumerWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDistanceProvider.notifier).change(null);
          // Navigate to CustomSearchView
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FeatureSwitches.searchV2
                ? CustomSearchViewV2()
                : const CustomSearchView(),
          ));
        },
        child: Stack(
          children: [
            Container(
              height: 60,
              margin: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        searchBlueIcon,
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).CustomSearchView_Search,
                    style: const TextStyle(
                      color: Color(0xFF898A8D),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
