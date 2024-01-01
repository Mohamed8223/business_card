import 'package:clinigram_app/features/chats/data/models/utils.dart';
import 'package:clinigram_app/features/profile/utils.dart';

import '../../chats.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({
    super.key,
    required this.chatModel,
  });
  final ChatModel chatModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  bool isNewchat = true;
  final messageController = TextEditingController();
  late ChatMemberModel reciverUser;
  late String cureentUserId;

  @override
  void initState() {
    super.initState();
    cureentUserId = ref.read(currentUserProfileProvider).id;
    reciverUser = widget.chatModel.members
        .firstWhere((member) => member.id != cureentUserId);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final messagsListList =
        ref.watch(messagesLisStreamProvider(widget.chatModel.id));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            const BackButton(),
            CircleAvatar(
              backgroundImage: reciverUser.imageUrl.isEmpty
                  ? getDefaultProfilePicByAccountTypeString(
                      reciverUser.accountType) as ImageProvider
                  : CachedNetworkImageProvider(reciverUser.imageUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              reciverUser.getLocalizedFullName(ref),
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: 10,
            indent: 10,
            endIndent: 10,
            color: Colors.black,
          ),
          Expanded(
              child: messagsListList.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return Center(
                          child: Text(S.of(context).ChatView_noMessagesText));
                    } else {
                      isNewchat = false;
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 0),
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 8,
                                ),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index].copyWith(
                                  isMyMessgae: cureentUserId ==
                                      messages[index].senderId);
                              if (!message.isMyMessgae && !message.isRead) {
                                ref
                                    .read(chatMessagesProvider.notifier)
                                    .markMessageAsRead(widget.chatModel.id,
                                        messages[index].id!);
                              }
                              return MessageWidget(message: message);
                            }),
                      );
                    }
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const SizedBox())),
          ChatInputField(
            messageController: messageController,
            onAttatchmentConfirmed: (file, messageType) {
              final messageModel = MessageModel(
                  senderId: cureentUserId,
                  content: file.path,
                  messageType: messageType,
                  timestamp: DateTime.now());

              ref.read(chatMessagesProvider.notifier).sendChatAttatchment(
                  messageModel, widget.chatModel, isNewchat);
            },
            onSend: (text) {
              final messageModel = MessageModel(
                  senderId: cureentUserId,
                  content: text,
                  messageType: ChatMessageType.text,
                  timestamp: DateTime.now());

              ref
                  .read(chatMessagesProvider.notifier)
                  .sendChatMessage(messageModel, widget.chatModel, isNewchat);
            },
          ),
        ],
      ),
    );
  }
}
