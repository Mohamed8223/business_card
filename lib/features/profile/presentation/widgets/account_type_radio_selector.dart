import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class AccountTypeRadioSelector extends ConsumerWidget {
  const AccountTypeRadioSelector({
    super.key,
    required this.onChanged,
  });
  final Function(AccontType) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(accountTypeProvider) ?? AccontType.user;
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 0,
          title: Text(S.of(context).AccountTypeRadioSelector_Account_Type),
          leading: Image.asset(
            genderIcon,
            width: 25,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                value: AccontType.user,
                groupValue: selectedType,
                onChanged: (user) {
                  ref
                      .read(accountTypeProvider.notifier)
                      .update((state) => user);

                  onChanged(user!);
                },
                title: Text(S.of(context).AccountTypeRadioSelector_User),
              ),
            ),
            Expanded(
              child: RadioListTile(
                value: AccontType.doctor,
                groupValue: selectedType,
                onChanged: (doctor) {
                  ref
                      .read(accountTypeProvider.notifier)
                      .update((state) => doctor);
                  onChanged(doctor!);
                },
                title: Text(S.of(context).AccountTypeRadioSelector_Doctor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
