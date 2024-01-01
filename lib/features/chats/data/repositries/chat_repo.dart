import 'dart:io';

import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/core.dart';
import '../../chats.dart';

class ChatRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Stream<List<ChatModel>> getChatsList(UserModel userModel) {
    return _firebaseFirestore
        .collection(chatsCollection)
        .where('members', arrayContains: userModel.toChatMemeber().toJson())
        .snapshots()
        .asyncMap(
      (chats) async {
        List<ChatModel> chatsList = [];
        for (var chatMap in chats.docs) {
          final unreadMessages = await _firebaseFirestore
              .collection(chatsCollection)
              .doc(chatMap.id)
              .collection(messagesCollection)
              .where('sender_id', isNotEqualTo: userModel.id)
              .where('is_read', isEqualTo: false)
              .get();

          chatsList.add(ChatModel.fromDocument(chatMap)
              .copyWith(unreadCount: unreadMessages.size));
        }
        return chatsList;
      },
    );
  }

  Stream<List<MessageModel>> getChatsMessages(String chatId) {
    return _firebaseFirestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy(
          'timestamp',
        )
        .snapshots()
        .map(
      (messages) {
        List<MessageModel> messagesList = [];
        for (var messageMap in messages.docs) {
          messagesList.add(MessageModel.fromDocument(messageMap));
        }
        return messagesList;
      },
    );
  }

  readMessage(String chatId, String messageId) {
    _firebaseFirestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .doc(messageId)
        .update({'is_read': true});
  }

  Future sendMessage(MessageModel messageModel, ChatModel? chatModel,
      {bool isNew = false}) async {
    if (isNew) {
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel!.id)
          .set(chatModel.toJson());
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel.id)
          .collection(messagesCollection)
          .add(messageModel.toJson());
    } else {
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel!.id)
          .collection(messagesCollection)
          .add(messageModel.toJson());
      _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel.id)
          .update({'last_message': messageModel.toJson()});
    }
  }

  Future sendAttatchment(MessageModel messageModel, ChatModel? chatModel,
      {bool isNew = false}) async {
    if (isNew) {
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel!.id)
          .set(chatModel.toJson());
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel.id)
          .collection(messagesCollection)
          .add(messageModel.toJson());
    } else {
      await _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel!.id)
          .collection(messagesCollection)
          .add(messageModel.toJson());
      _firebaseFirestore
          .collection(chatsCollection)
          .doc(chatModel.id)
          .update({'last_message': messageModel.toJson()});
    }
  }

  Future<String> uploadChatAttatchment(File file) async {
    String fileUrl =
        await uploadFileToFirebase(file, chatsAttatchmentsCollection);
    return fileUrl;
  }
}

final chatRepoProvider = Provider<ChatRepo>((ref) {
  return ChatRepo();
});
