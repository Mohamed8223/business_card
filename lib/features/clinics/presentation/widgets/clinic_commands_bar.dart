import 'dart:io';

import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinic_details.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_commands_item.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';

class ClinicCommandsBar extends ConsumerStatefulWidget {
  const ClinicCommandsBar({super.key});

  @override
  ConsumerState<ClinicCommandsBar> createState() => _ClinicCommandsBarState();
}

class _ClinicCommandsBarState extends ConsumerState<ClinicCommandsBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clinicModel = ref.watch(clinicDetailsViewModelProvider);
    final user = ref.read(currentUserProfileProvider);
    var userHasFollowedClinic = clinicModel.followers.contains(user.id);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClinicCommandsItem(
              title: 'الموقع',
              icon: locationIcon,
              color: Theme.of(context).colorScheme.primary,
              onTap: () async {
                if (clinicModel.location == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('لا يوجد موقع للعيادة'),
                  ));
                  return;
                }
                await MapsLauncher.launchCoordinates(
                    clinicModel.location!.latitude,
                    clinicModel.location!.longitude);
              },
            ),
            ClinicCommandsItem(
              title: 'مشاركة',
              color: Theme.of(context).colorScheme.primary,
              icon: shareIcon,
              onTap: () {
                String path=ClinicModel.init().id;
                if (path == '') {
                  Share.share('https://clinigr.web.app/');
                }else{
                  Share.share('https://clinigr.web.app/');
                }
              
                
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   // TODO: implement
                //   content: Text('هذه الامكانية غير متاحه حاليا'),
                // ));
              },
            ),
            ClinicCommandsItem(
              title: 'اتصال',
              icon: callIcon,
              color: Theme.of(context).colorScheme.primary,
              isActive: clinicModel.phone.isNotEmpty,
              onTap: () async {
                final phone = clinicModel.phone;
                var normalizedPhoneNumber = phone;
                if (normalizedPhoneNumber.isNotEmpty &&
                    !normalizedPhoneNumber.startsWith('+')) {
                  normalizedPhoneNumber = '+972 $normalizedPhoneNumber';
                }
                Uri phoneNum = Uri.parse(
                    'tel:${normalizedPhoneNumber.replaceAll(' ', '')}');

                await launchUrl(phoneNum);
              },
            ),
            ClinicCommandsItem(
              title: 'رسالة',
              icon: chatsIcon,
              color: primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  // TODO: implement
                  content: Text('هذه الامكانية غير متاحه حاليا'),
                ));
              },
            ),
            ClinicCommandsItem(
              title: "${clinicModel.followers.length} متابع",
              icon: userHasFollowedClinic ? unfollowIcon : followIcon,
              color: primaryColor,
              onTap: () async {
                if (userHasFollowedClinic) {
                  final result = await ref
                      .read(clinicsRepoProvider)
                      .unfollowClinic(clinicModel, user.id);

                  if (result) {
                    ref.read(clinicDetailsViewModelProvider.notifier).update(
                        (state) => clinicModel.copyWith(
                            followers: clinicModel.followers
                                .where((element) => element != user.id)
                                .toList()));
                  }
                } else {
                  final result = await ref
                      .read(clinicsRepoProvider)
                      .followClinic(clinicModel, user.id);

                  if (result) {
                    ref.read(clinicDetailsViewModelProvider.notifier).update(
                        (state) => clinicModel.copyWith(
                            followers: [...clinicModel.followers, user.id]));
                  }
                }
              },
            ),
          ],
        ));
  }
}
