import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../admin_manage.dart';

class CitiesManageView extends ConsumerWidget {
  const CitiesManageView({super.key});
  _listenToState(BuildContext context, WidgetRef ref) {
    ref.listen(requestResponseProvider, (_, state) {
      state.whenOrNull(
        sucess: (message, addtionalData) => context
            .showSnackbarSuccess(S.of(context).CitiesManageView_successMessage),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToState(context, ref);
    final cities = ref.watch(citiesProvider).value!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClinigramButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => const CityAddEditDialog());
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30)),
              child: Text(
                S.of(context).CitiesManageView_addButton,
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
        title: Text(S.of(context).CitiesManageView_citiesTitle),
      ),
      body: cities.isEmpty
          ? Center(
              child: Text(S.of(context).CitiesManageView_emptyCitiesList),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemBuilder: (context, index) =>
                    CityItemCard(city: cities[index]),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: cities.length,
              ),
            ),
    );
  }
}
