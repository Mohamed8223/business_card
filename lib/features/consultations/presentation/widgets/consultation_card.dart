import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../chats/chats.dart';
import '../../../doctors/doctors.dart';
import '../../../profile/profile.dart';
import '../../consultations.dart';

class ConsultationCard extends ConsumerWidget {
  const ConsultationCard({
    super.key,
    required this.consultation,
  });

  final ConsultationModel consultation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProfileProvider);
    final userType = currentUser.accontType;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: primaryColor),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.27),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: S.of(context).ConsultationCard_consultationTitle,
                style: context.textTheme.titleSmall!
                    .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: consultation.description,
                    style: context.textTheme.titleMedium,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: S.of(context).ConsultationCard_attachmentLabel,
                    style: context.textTheme.titleSmall!.copyWith(
                        color: primaryColor, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: consultation.attatchmentType.name,
                        style: context.textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
                if (consultation.attatchmentType != AttatchmentType.none)
                  IconButton(
                    onPressed: () {
                      context.push(
                        AttatechmentViewerView(
                          url: consultation.fileUrl,
                          attatchmentType: consultation.attatchmentType,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: primaryColor,
                    ),
                  )
              ],
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            Text(
              S.of(context).ConsultationCard_patientLabel,
              style: context.textTheme.titleSmall!
                  .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              consultation.patient.getLocalizedFullName(ref),
              style: context.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (userType != AccontType.user)
              IconButton(
                  onPressed: () {
                    final chatId =
                        generateChatId(currentUser.id, consultation.patient.id);
                    context.push(ChatView(
                      chatModel: ChatModel(
                        id: chatId,
                        lastMessage: null,
                        members: [
                          currentUser.toChatMemeber(),
                          consultation.patient.toChatMemeber()
                        ],
                      ),
                    ));
                  },
                  icon: Image.asset(
                    chatsIcon,
                    color: primaryColor,
                    width: 22,
                  )),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            Text(
              S.of(context).ConsultationCard_doctorLabel,
              style: context.textTheme.titleSmall!
                  .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              consultation.doctor?.getLocalizedFullName(ref) ??
                  S.of(context).ConsultationCard_awaitingTransfer,
              style: context.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (userType == AccontType.admin)
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: context.screenSize.height * 0.8,
                      ),
                      builder: (context) => DoctorsListSelector(
                          consultationId: consultation.id,
                          currentDoctor: consultation.doctor),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: primaryColor,
                    size: 22,
                  )),
          ],
        ));
  }
}
