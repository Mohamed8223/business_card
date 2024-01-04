import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/main/main_layout.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../doctors/presentation/views/information_register_screen.dart';
import '../../auth.dart';

class OTPVerificationView extends HookConsumerWidget {
   OTPVerificationView({
    super.key,
    required this.receivedID,
    required this.phone,
  });

  final String receivedID;
  final String phone;
final otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    ref.listen(authProvider, (_, state) {
      state.whenOrNull(
        codeVerified: (
          isProfileCompleted,
        ) {
          context.showSnackbarSuccess(S.of(context).otp_confirmCodeButton);
          isProfileCompleted
              ? context.pushAndRemoveOthers(const MainLayout())
              : ref.read(accountTypeProvider) == null
                  ? context
                      .pushAndRemoveOthers(const AccountTypeView(fromOtp: true))
                  : context.pushAndRemoveOthers(InformationRegisterScreen(
                      isFirst: true,
                    ));
        },
        error: (message, addtionalData) => context.showSnackbarError(message),
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: context.screenSize.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).otp_title,
                  style: context.textTheme.titleLarge!.copyWith(
                      color: context.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  S.of(context).otp_verificationMessage,
                ),
                const SizedBox(
                  height: 55,
                ),
                SizedBox(
                  width: 300,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      controller: otpCodeController,
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      length: 6,
                      cursorColor: context.theme.colorScheme.primary,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        activeColor: Colors.grey,
                        disabledColor: Colors.grey,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                ClinigramButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).otpVerification(
                          phone,
                          otpCodeController.text,
                          receivedID,
                        );
                        
                  },
                  child: Text(
                    S.of(context).otp_confirmCodeButton,
                    style: context.textTheme.titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).otp_resendMessage),
                    TextButton(
                        onPressed: () {
                          //todo resend code
                        },
                        child: Text(
                          S.of(context).otp_resendButton,
                          style: context.textTheme.bodyMedium!.copyWith(
                              color: context.theme.colorScheme.primary),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
void dispose() {
   
    otpCodeController.dispose();
}
}
