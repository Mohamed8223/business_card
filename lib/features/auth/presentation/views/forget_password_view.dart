import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgetPasswordView extends ConsumerWidget {
  const ForgetPasswordView({super.key});

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
                  S.of(context).ForgetPasswordView_title,
                  style: context.textTheme.titleLarge!.copyWith(
                      color: context.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  S.of(context).ForgetPasswordView_resetPasswordText,
                ),
                const SizedBox(
                  height: 55,
                ),
                Center(
                  child: Image.asset(
                    forgetPasswordBackgroundImage,
                    width: context.screenSize.width * 0.7,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ClinigramTextField(
                  hintText: S.of(context).ForgetPasswordView_mobileNumberHint,
                  controller: TextEditingController(),
                  icon: phoneIcon,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: ClinigramButton(
                    onPressed: () {},
                    child: Text(
                      S.of(context).ForgetPasswordView_sendCodeButton,
                      style: context.textTheme.titleMedium!
                          .copyWith(color: Colors.white),
                    ),
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
