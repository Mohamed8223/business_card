import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/consultations/consultations.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../doctors.dart';

class DoctorsListSelector extends ConsumerStatefulWidget {
  const DoctorsListSelector({
    super.key,
    required this.currentDoctor,
    required this.consultationId,
  });
  final UserModel? currentDoctor;
  final String consultationId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DoctorsListSelectorState();
}

class _DoctorsListSelectorState extends ConsumerState<DoctorsListSelector> {
  @override
  void initState() {
    ref.read(doctorsProvider.notifier).getDoctorsList();
    selectedDoctor = widget.currentDoctor;
    super.initState();
  }

  late UserModel? selectedDoctor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenSize.height * 0.8,
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 3,
                child: Text(
                  S.of(context).DoctorsListSelector_Doctors,
                  style: context.textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: selectedDoctor != widget.currentDoctor
                    ? GestureDetector(
                        onTap: () {
                          context.pop();
                          ref
                              .read(consultationProvider.notifier)
                              .updateConsultationDoctor(
                                  widget.consultationId, selectedDoctor!);
                        },
                        child: Text(
                          S.of(context).DoctorsListSelector_Confirm,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              final doctorsList = ref.watch(doctorsProvider);
              final requestState = ref.watch(requestResponseProvider);
              return Expanded(
                child: requestState ==
                        RequestResponseModel.loading(
                            loadingType: LoadingTypes.inline)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: doctorsList.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            setState(() {
                              selectedDoctor = doctorsList[index];
                            });
                          },
                          leading: CircleAvatar(
                            backgroundImage: doctorsList[index].imageUrl.isEmpty
                                ? getDefaultProfilePicByAccountType(
                                        doctorsList[index].accontType)
                                    as ImageProvider
                                : CachedNetworkImageProvider(
                                    doctorsList[index].imageUrl),
                          ),
                          title: Text(
                              doctorsList[index].getLocalizedFullName(ref)),
                          trailing: selectedDoctor == doctorsList[index]
                              ? const Icon(
                                  Icons.check_circle,
                                  color: primaryColor,
                                )
                              : null,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
