import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/main/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/auth.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(checkCurrentUserProvider, (previous, next) {
      if (next.value != null) {
        context.pushAndRemoveOthers(
          next.value!.accontType == AccontType.doctor ||
                  next.value!.accontType == AccontType.user
              ? const MainLayout()
              : const MainLayout(),
        );
      } else {
        context.pushAndRemoveOthers(const LoginView());
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              clinigramLogo,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
