import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/category_visibilty_provider.dart';

class VisibiltyToggle extends ConsumerStatefulWidget {
  const VisibiltyToggle({super.key, this.currentValue});
  final bool? currentValue;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryVisibiltyToggleState();
}

class _CategoryVisibiltyToggleState extends ConsumerState<VisibiltyToggle> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.currentValue != null) {
        ref
            .read(visibiltyToggleProvider.notifier)
            .update((state) => widget.currentValue!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibile = ref.watch(visibiltyToggleProvider);
    return SwitchListTile(
        title: Text(visibile
            ? S.of(context).VisibiltyToggle_Visible
            : S.of(context).VisibiltyToggle_Not_Visible),
        value: visibile,
        onChanged: (value) {
          ref.read(visibiltyToggleProvider.notifier).update((state) => value);
        });
  }
}
