import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../profile/profile.dart';
import '../chats.dart';

final chatsStreamProvider = StreamProvider<List<ChatModel>>((ref) async* {
  final userModel = ref.read(currentUserProfileProvider);
  final chatsListStream = ref.watch(chatRepoProvider).getChatsList(userModel);
  yield* chatsListStream;
});
