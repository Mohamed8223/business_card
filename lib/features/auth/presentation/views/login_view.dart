import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/presentation/views/translate_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class LoginView extends HookConsumerWidget with ValidationMixin {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (_, state) {
      state.whenOrNull(
        codeSent: (receivedID, phone) {
          context.showSnackbarSuccess(S.of(context).LoginView_verify_message);
          context.push(
            OTPVerificationView(
              receivedID: receivedID,
              phone: phone,
            ),
          );
        },
        error: (message, addtionalData) => context.showSnackbarError(message),
      );
    });
    final formkey = GlobalKey<FormState>();

    final phoneController = useTextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(S.of(context).Select_language),
                    content: const LanguageSelectionWidget(),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.language, // Change to the icon you prefer
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    S.of(context).LoginView_login,
                    style: context.textTheme.titleLarge!.copyWith(
                        color: context.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    clinigramLogo,
                    width: 120,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  PhoneTextField(
                    controller: phoneController,
                    onSubmitted: (value) {
                      if (formkey.currentState!.validate()) {
                        ref
                            .read(authProvider.notifier)
                            .phoneAuthintication(phoneController.text);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ClinigramButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        ref
                            .read(authProvider.notifier)
                            .phoneAuthintication(phoneController.text);
                      }
                    },
                    child: Text(
                      S.of(context).LoginView_login,
                      style: context.textTheme.titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  if (FeatureSwitches.googleAndFacebookLogin) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 20,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          S.of(context).LoginView_or,
                          style: context.textTheme.titleMedium,
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 20,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SocialAuthWidget(),
                  ],
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).LoginView_register_ask),
                      TextButton(
                          onPressed: () {
                            context.push(const AccountTypeView());
                          },
                          child: Text(
                            S.of(context).LoginView_new_account_ask,
                            style: context.textTheme.titleMedium!.copyWith(
                                decoration: TextDecoration.underline,
                                color: context.theme.colorScheme.primary),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
