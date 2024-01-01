import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../chats.dart';

class ChatMessagesNotifier extends StateNotifier<List<MessageModel>> {
  ChatMessagesNotifier(this._ref) : super([]);
  final Ref _ref;

  Future sendChatMessage(
      MessageModel messageModel, ChatModel chatModel, bool isNew) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loadingType: LoadingTypes.inline);
      final preparedChatModel = chatModel.copyWith(lastMessage: messageModel);
      await _ref
          .read(chatRepoProvider)
          .sendMessage(messageModel, preparedChatModel, isNew: isNew);
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.init();
    }
  }

  Future sendChatAttatchment(
      MessageModel messageModel, ChatModel chatModel, bool isNew) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loadingType: LoadingTypes.inline);
      final preparedChatModel = chatModel.copyWith(lastMessage: messageModel);
      final attatchmentUrl = await _ref
          .read(chatRepoProvider)
          .uploadChatAttatchment(File(messageModel.content));
      messageModel = messageModel.copyWith(content: attatchmentUrl);
      await _ref
          .read(chatRepoProvider)
          .sendAttatchment(messageModel, preparedChatModel, isNew: isNew);
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.init();
    }
  }

  markMessageAsRead(String chatId, String messageId) {
    _ref.read(chatRepoProvider).readMessage(chatId, messageId);
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<MessageModel>>((ref) {
  return ChatMessagesNotifier(ref);
});

final messagesLisStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) async* {
  final chatsListStream = ref.watch(chatRepoProvider).getChatsMessages(chatId);
  yield* chatsListStream;
});
