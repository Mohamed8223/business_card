import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ChangePasswordView_appBarTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ClinigramTextField(
                hintText: S.of(context).ChangePasswordView_oldPasswordHint,
                controller: TextEditingController(),
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              ClinigramTextField(
                hintText: S.of(context).ChangePasswordView_newPasswordHint,
                controller: TextEditingController(),
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              ClinigramTextField(
                hintText: S.of(context).ChangePasswordView_confirmPasswordHint,
                controller: TextEditingController(),
                obscureText: true,
              ),
              const SizedBox(
                height: 50,
              ),
              ClinigramButton(
                onPressed: () {},
                child: Text(
                  S.of(context).ChangePasswordView_confirmButtonLabel,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
