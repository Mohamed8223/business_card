import 'package:flutter/material.dart';

import '../core.dart';

class InlineLoadingWidget extends StatelessWidget {
  const InlineLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.theme.colorScheme.primary,
      ),
    );
  }
}
