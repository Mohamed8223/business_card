import 'package:clinigram_app/core/models/db_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class StringsChipsList extends ConsumerWidget {
  final List<DBString> values;
  final AutoDisposeStateProvider<DBString?> selectedValueProvider;

  const StringsChipsList(this.values, this.selectedValueProvider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuesList = values;
    final selectedValue = ref.watch(selectedValueProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: valuesList
              .map((e) => GestureDetector(
                    onTap: () => ref
                        .read(selectedValueProvider.notifier)
                        .update((state) => e),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: selectedValue == e
                                ? primaryColor
                                : const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          e.displayValue,
                          style: TextStyle(
                              fontSize: 17,
                              color: selectedValue == e
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
