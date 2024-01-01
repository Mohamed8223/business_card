import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SocialAuthWidget extends ConsumerWidget {
  const SocialAuthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).signInWithGoogle();
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.4,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                googleIcon,
                width: 35,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).signInWithFacebook();
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.4,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                facebookIcon,
                width: 35,
              ),
            ),
          ),
        )
      ],
    );
  }
}
