import '../core.dart';
import 'package:flutter/material.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).CustomErrorWidget_error_message,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 150,
            height: 40,
            child: ClinigramButton(
              onPressed: onTap!,
              child: Text(
                S.of(context).CustomErrorWidget_try_again,
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
