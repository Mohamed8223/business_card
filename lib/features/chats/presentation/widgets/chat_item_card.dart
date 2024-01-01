import 'package:clinigram_app/features/chats/data/models/utils.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';

import '../../chats.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../../profile/profile.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class ChatItemCard extends ConsumerWidget {
  const ChatItemCard({
    super.key,
    required this.chatModel,
  });
  final ChatModel chatModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initializeDateFormatting(ref.watch(appLanguageProvider).languageCode, null);

    final currentUserId = ref.read(currentUserProfileProvider).id;
    final chatMember = chatModel.members
        .where((element) => element.id != currentUserId)
        .single;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: chatMember.imageUrl.isEmpty
              ? getDefaultProfilePic(ref) as ImageProvider
              : CachedNetworkImageProvider(chatMember.imageUrl),
        ),
        title: Text(
          chatMember.getLocalizedFullName(ref),
          style: context.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessagePreview(chatModel),
          style: context.textTheme.titleSmall!.copyWith(color: Colors.grey),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: 70,
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMessageDate(chatModel.lastMessage!.timestamp,
                      ref.watch(appLanguageProvider).languageCode),
                  style: context.textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                  ),
                ),
                if (chatModel.unreadCount != 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.colorScheme.primary,
                    ),
                    child: Text(
                      '${chatModel.unreadCount}',
                      style: context.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String lastMessagePreview(ChatModel chatModel) {
    switch (chatModel.lastMessage!.messageType) {
      case ChatMessageType.text:
        return chatModel.lastMessage!.content;
      case ChatMessageType.image:
        return S.current.ChatItemCard_lastMessageImage;
      case ChatMessageType.pdf:
        return S.current.ChatItemCard_lastMessagePDF;
      default:
        return '';
    }
  }
}
