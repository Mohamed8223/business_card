import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordView extends ConsumerWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: context.screenSize.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).ResetPasswordView_title,
                  style: context.textTheme.titleLarge!.copyWith(
                      color: context.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                const SizedBox(
                  height: 55,
                ),
                Center(
                  child: Image.asset(
                    resetPasswordBackgroundImage,
                    width: context.screenSize.width * 0.5,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ClinigramTextField(
                  hintText: S.of(context).ResetPasswordView_passwordHint,
                  obscureText: true,
                  controller: TextEditingController(),
                  icon: lockIcon,
                ),
                const SizedBox(
                  height: 20,
                ),
                ClinigramTextField(
                  hintText: S.of(context).ResetPasswordView_confirmPasswordHint,
                  obscureText: true,
                  controller: TextEditingController(),
                  icon: lockIcon,
                ),
                const SizedBox(
                  height: 40,
                ),
                ClinigramButton(
                  onPressed: () {},
                  child: Text(
                    S.of(context).ResetPasswordView_confirmButtonLabel,
                    style: context.textTheme.titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
