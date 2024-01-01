import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/search/providers/location_provider.dart';
import 'package:clinigram_app/features/search/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../translation/data/generated/l10n.dart';


class DistanceFilter extends HookConsumerWidget {
  const DistanceFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? distance = ref.read(selectedDistanceProvider.notifier).distance;
    var _controller =
        useTextEditingController(text: distance?.toInt().toString());
    final value=useState(distance) ;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('المسافة '),
              SizedBox(
                width: 100,
                child: TextField(
                  maxLines: 1,
                  maxLength: 3,
                  enabled: false,
                  controller: _controller,
                  decoration: const InputDecoration(
                    suffix: Text('كم'),
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            onChanged: (d) {
              value.value=d;
              ref.read(locationProvider.notifier).getLocation();
              _controller.text = d.toInt().toString();
            },
            value: value.value ?? 400,
            label: 'المسافة',
            min: 1,
            max: 400,
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 كم'),
              Text('400 كم'),
            ],
          ),
          const SizedBox(height: 10),
          ClinigramButton(
              onPressed: () {
                context.pop();
                ref.read(selectedDistanceProvider.notifier).change(value.value);
                ref
                    .read(customSearchProvider.notifier)
                    .performDoctorsCustomSearch();
              },
              child: Text(S.of(context).CustomSearchView_Search)),
        ],
      ),
    );
  }
}
