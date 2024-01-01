import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({
    super.key,
    this.currentGender = Gender.female,
    required this.onChanged,
  });
  final Gender currentGender;
  final Function(Gender) onChanged;
  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  @override
  void initState() {
    selectedGender = widget.currentGender;
    super.initState();
  }

  late Gender selectedGender;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 0,
          title: Text(S.of(context).GenderSelector_gender),
          leading: Image.asset(
            genderIcon,
            width: 25,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: Gender.female,
                groupValue: selectedGender,
                onChanged: (female) {
                  setState(() {
                    selectedGender = female!;
                  });
                  widget.onChanged(selectedGender);
                },
                title: Text(S.of(context).GenderSelector_female),
              ),
            ),
            Expanded(
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                value: Gender.male,
                groupValue: selectedGender,
                onChanged: (male) {
                  setState(() {
                    selectedGender = male!;
                  });
                  widget.onChanged(selectedGender);
                },
                title: Text(S.of(context).GenderSelector_male),
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }
}
