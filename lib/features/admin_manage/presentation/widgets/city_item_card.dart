import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/utils.dart';
import '../../../../core/core.dart';
import '../../admin_manage.dart';

class CityItemCard extends ConsumerWidget {
  const CityItemCard({
    super.key,
    required this.city,
  });

  final CityModel city;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        horizontalTitleGap: 0,
        leading: const Icon(
          Icons.location_pin,
          color: primaryColor,
        ),
        title: Text(city.getLocalizedName(ref)),
        trailing: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => CityAddEditDialog(
                        city: city,
                      ));
            },
            icon: const Icon(
              Icons.edit,
              color: secondryColor,
            )));
  }
}
