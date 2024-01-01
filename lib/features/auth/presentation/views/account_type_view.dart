import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/core/views/terms_and_conditions_view.dart';
import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../doctors/presentation/views/information_register_screen.dart';

class AccountTypeView extends ConsumerStatefulWidget {
  const AccountTypeView({super.key, this.fromOtp = false});
  final bool fromOtp;

  @override
  ConsumerState<AccountTypeView> createState() => _AccountTypeViewState();
}

class _AccountTypeViewState extends ConsumerState<AccountTypeView> {
  bool _agreeToTerms = false;
  bool _agreeToAds = false;
  bool _unselectTermsError = false;

  void _launchTerms() {
    // Navigate to Terms and Conditions View
    context.push(const TermsAndConditionsView());
  }

  void _launchPrivacy() {
    // Navigate to Privacy Policy View
    context.push(const PrivacyPolicyView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: S.of(context).AccountTypeView_welcome_message,
                  style: context.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '   Clinicate    ',
                      style: context.textTheme.titleLarge!.copyWith(
                          color: context.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  S.of(context).AccountTypeView_get_started,
                  style: context.textTheme.titleMedium,
                ),
              ),
              Text(
                S.of(context).AccountTypeView_choose_account_type,
                style: context.textTheme.titleMedium!
                    .copyWith(color: context.theme.colorScheme.primary),
              ),
              const SizedBox(
                height: 50,
              ),
              const AccountTypeSelector(),
              const SizedBox(height: 30),
              CheckboxListTile(
                title: RichText(
                  text: TextSpan(
                    text: '${S.of(context).Agree} ',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color),
                    children: <TextSpan>[
                      TextSpan(
                        text: S.of(context).Terms_and_conditions,
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchTerms,
                      ),
                      TextSpan(text: ' ${S.of(context).And} '),
                      TextSpan(
                        text: S.of(context).PrivacyPolicyView_privacy_policy,
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchPrivacy,
                      ),
                    ],
                  ),
                ),
                value: _agreeToTerms,
                fillColor: MaterialStatePropertyAll<Color>(_agreeToTerms
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white),
                onChanged: (bool? value) {
                  setState(() {
                    _agreeToTerms = value!;
                    if (value && _unselectTermsError) {
                      _unselectTermsError = false;
                    }
                  });
                },
                isError: _unselectTermsError,
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
              // const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(S.of(context).AgreeToAdds),
                value: _agreeToAds,
                onChanged: (bool? value) {
                  setState(() {
                    _agreeToAds = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
              const SizedBox(height: 30),
              ClinigramButton(
                onPressed: _agreeToTerms
                    ? () {
                        (widget.fromOtp)
                            ? context.push(InformationRegisterScreen(
                                isFirst: true,
                              ))
                            : context.push(const UserSignUpView());
                      }
                    : () {
                        setState(() {
                          _unselectTermsError = true;
                        });
                        context.showSnackbarError('وافق على الشروط أولاَ');
                      }, // Disable the button if terms are not agreed to
                child: Text(S.of(context).AccountTypeView_next),
              ),
              const SizedBox(
                height: 24,
              ),
              if (!widget.fromOtp)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).AccountTypeView_already_have_account),
                    TextButton(
                      onPressed: () {
                        context.pushAndRemoveOthers(const LoginView());
                      },
                      child: Text(
                        S.of(context).AccountTypeView_login_button,
                        style: context.textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            color: context.theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
