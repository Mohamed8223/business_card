import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../../consultations/consultations.dart';
import '../../../delete_user/presentation/views/delete_user_account.dart';

class ProfileBottomSheet extends ConsumerWidget {
  const ProfileBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      requestResponseProvider,
      (_, state) {
        state.whenOrNull(
          sucess: (message, addtionalData) {
            context.pushAndRemoveOthers(const LoginView());
          },
          error: (message, addtionalData) {
            context.showSnackbarError(message);
          },
        );
      },
    );
    return Column(
      children: [
        // BottomSheetItem(
        //   title: 'الإعدادات ',
        //   icon: settingsIcon,
        //   onTap: () => context.push(
        //     const SettingsView(),
        //   ),
        // ),
        BottomSheetItem(
          title: S.of(context).ProfileBottomSheet_My_Consultations,
          icon: consultationIcon,
          iconColor: context.theme.colorScheme.secondary,
          onTap: () => context.push(const ConsultationView()),
        ),
        BottomSheetItem(
          title: S.of(context).ProfileBottomSheet_Share_the_App,
          icon: shareAppIcon,
          iconColor: context.theme.colorScheme.secondary,
        ),
        BottomSheetItem(
          title: S.of(context).ProfileBottomSheet_Privacy_Policy,
          icon: privacyPolicyIcon,
          iconColor: context.theme.colorScheme.secondary,
          onTap: () => context.push(const PrivacyPolicyView()),
        ),
        BottomSheetItem(
          title: S.of(context).ProfileBottomSheet_About_Us,
          icon: aboutUsIcon,
          iconColor: context.theme.colorScheme.secondary,
          onTap: () => context.push(const AboutUsView()),
        ),
        BottomSheetItem(
          title: S.of(context).ProfileBottomSheet_delete_Account,
          icon: deleteAccountIcon,
          iconColor: context.theme.colorScheme.secondary,
          onTap: () => context.push(const DeleteUserAccount()),
        ),
        BottomSheetItem(
            title: S.of(context).ProfileBottomSheet_Logout,
            icon: logoutIcon,
            iconColor: context.theme.colorScheme.secondary,
            width: 30,
            onTap: () {
              ref.read(authProvider.notifier).logout();
              // to reset the current screen index to home screen
              //ref
              //    .watch(userLayoutCurrentIndexProvider.notifier)
              //    .update((state) => 0);

              //context.pushAndRemoveOthers(const LoginView());
            }),
      ],
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.width = 25,
    this.onTap,
  });
  final String title;
  final String icon;
  final Color? iconColor;
  final double width;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      title: Text(
        title,
        style: context.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Image.asset(
        icon,
        width: width,
        color: iconColor,
      ),
    );
  }
}
