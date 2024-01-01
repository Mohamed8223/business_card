import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MainCategoryType extends StatefulWidget {
  final ValueChanged<CategoryType>? onChanged;
  final bool isChecked;
  final String title;
  const MainCategoryType(
      {Key? key, this.onChanged, this.isChecked = false, this.title = 'تخصصي'})
      : super(key: key);

  @override
  State<MainCategoryType> createState() => _MainCategoryTypeState();
}

class _MainCategoryTypeState extends State<MainCategoryType> {
  late bool checked;
  @override
  void initState() {
    super.initState();
    checked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.title),
      value: checked,
      onChanged: (bool? value) {
        setState(() {
          checked = !checked;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(
              value! ? CategoryType.specialist : CategoryType.service);
        }
      },
    );
  }
}
