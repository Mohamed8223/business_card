import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class UserSignUpView extends HookConsumerWidget with ValidationMixin {
  const UserSignUpView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authProvider,
      (_, state) {
        state.whenOrNull(
          codeSent: (receivedID, phone) {
            context
                .showSnackbarSuccess(S.of(context).UserSignUpView_codeMessage);
            context.push(
              OTPVerificationView(
                receivedID: receivedID,
                phone: phone,
              ),
            );
          },
          error: (message, addtionalData) => StateNotifierProvider,
        );
      },
    );
    final formKey = ref.read(authProvider.notifier).signUpformkey;
    final phoneController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: context.screenSize.width,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Image.asset(signUpIllustration),
                        ),
                        Text(
                          S.of(context).UserSignUpView_createAccountTitle,
                          style: context.textTheme.titleLarge!.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        PhoneTextField(
                          controller: phoneController,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ClinigramButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ref
                                  .read(authProvider.notifier)
                                  .phoneAuthintication(phoneController.text);
                            }
                          },
                          child: Text(
                            S.of(context).UserSignUpView_nextButtonLabel,
                            style: context.textTheme.titleMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (FeatureSwitches.googleAndFacebookLogin) ...[
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  endIndent: 20,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                S.of(context).UserSignUpView_orText,
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
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
