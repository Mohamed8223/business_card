import 'package:clinigram_app/core/widgets/visibilty_toggle.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../admin_manage.dart';

class CityAddEditDialog extends HookConsumerWidget with ValidationMixin {
  const CityAddEditDialog({super.key, this.city});
  final CityModel? city;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final cityNameArCon = useTextEditingController(text: city?.nameAr);
    final cityNameEnCon = useTextEditingController(text: city?.nameEn);
    final cityNameHeCon = useTextEditingController(text: city?.nameHe);
    final cityLocationCon = useTextEditingController(
        text: city?.cityLocation?.toFormattedString() ?? '');
    final isEdit = city != null;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit
                    ? S.of(context).CityAddEditDialog_editCityTitle
                    : S.of(context).CityAddEditDialog_addCityTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ClinigramTextField(
                hintText: S.of(context).CityAddEditDialog_cityNameHintText,
                validator: (name) => emptyValidation(name, context),
                controller: cityNameArCon,
              ),
              const SizedBox(
                height: 10,
              ),
              ClinigramTextField(
                hintText: S.of(context).CityAddEditDialog_cityNameHintText,
                validator: (name) => emptyValidation(name, context),
                controller: cityNameEnCon,
              ),
              const SizedBox(
                height: 10,
              ),
              ClinigramTextField(
                hintText: S.of(context).CityAddEditDialog_cityNameHintText,
                validator: (name) => emptyValidation(name, context),
                controller: cityNameHeCon,
              ),
              const SizedBox(
                height: 10,
              ),
              ClinigramTextField(
                hintText: S.of(context).CityAddEditDialog_coordinatesHintText,
                controller: cityLocationCon,
                validator: (location) => locationValidation(location),
              ),
              const SizedBox(
                height: 10,
              ),
              VisibiltyToggle(
                currentValue: city?.visible,
              ),
              const SizedBox(
                height: 30,
              ),
              ClinigramButton(
                onPressed: () {
                  final visible = ref.read(visibiltyToggleProvider);

                  if (formKey.currentState!.validate()) {
                    context.pop();
                    isEdit
                        ? ref.read(citiesProvider.notifier).updateCity(
                            CityModel(
                                id: city!.id,
                                nameAr: cityNameArCon.text,
                                nameEn: cityNameEnCon.text,
                                nameHe: cityNameHeCon.text,
                                cityLocation:
                                    getGeopointFrommText(cityLocationCon.text),
                                visible: visible))
                        : ref.read(citiesProvider.notifier).addNewCity(
                            CityModel(
                                nameAr: cityNameArCon.text,
                                nameEn: cityNameEnCon.text,
                                nameHe: cityNameHeCon.text,
                                cityLocation:
                                    getGeopointFrommText(cityLocationCon.text),
                                visible: visible));
                  }
                },
                child: Text(
                  S.of(context).CityAddEditDialog_saveButtonText,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
