import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../admin_manage/admin_manage.dart';

class CityDropDown extends ConsumerWidget {
  final CityModel? value;
  final void Function(CityModel?)? onChanged; // Update the parameter type
  const CityDropDown({
    Key? key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late CityModel? currentCity;
    final citiesList = ref
        .read(citiesProvider)
        .asData!
        .value
        .where((element) => element.visible);
    if (value != null && citiesList.contains(value)) {
      currentCity = value!;
    } else {
      currentCity = null;
    }
    return DropdownButtonFormField<CityModel>(
      decoration: InputDecoration(
        hintText: S.of(context).CityDropDown_your_city,
      ),
      items: citiesList.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.getLocalizedName(ref)),
        );
      }).toList(),
      value: currentCity,
      validator: (value) {
        return null;
      },
      onChanged: onChanged,
    );
  }
}
