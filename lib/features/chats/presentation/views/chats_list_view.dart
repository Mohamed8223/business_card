import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../chats.dart';

class ChatsListView extends ConsumerWidget {
  const ChatsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsList = ref.watch(chatsStreamProvider);
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).ChatsListView_appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ClinigramSearchTextField(
              controller: TextEditingController(),
            ),
            Expanded(
                child: chatsList.when(
                    data: (chats) => chats.isEmpty
                        ? Center(
                            child:
                                Text(S.of(context).ChatsListView_noChatsText))
                        : ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => context.push(ChatView(
                                chatModel: chats[index],
                              )),
                              child: ChatItemCard(chatModel: chats[index]),
                            ),
                          ),
                    error: (error, stackTrace) => const Text("error"),
                    loading: () => const Center(
                          child: RepaintBoundary(
                            child: CircularProgressIndicator(),
                          ),
                        ))),
          ],
        ),
      ),
    );
  }
}
