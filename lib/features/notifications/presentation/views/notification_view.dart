import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '../widgets/widgets.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.notifications_none, color: secondryColor),
            const SizedBox(width: 8),
            Text(S.of(context).NotificationsView_appBarTitle),
          ],
        ),
      ),
      body: FirestoreQueryBuilder<NotificationModel>(
        query: ref.watch(notificationsRefProvider),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const InlineLoadingWidget();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).NotificationsView_errorText),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(notificationsRefProvider);
                    },
                    child: Text(S.of(context).NotificationsView_tryAgainText),
                  ),
                ],
              ),
            );
          }
          if (snapshot.docs.isEmpty) {
            return Center(
              child: Text(S.of(context).NotificationsView_noNotificationsText),
            );
          }
          return ListView.builder(
            // reverse: true,
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.docs.length,
            padding: const EdgeInsets.only(bottom: 8),
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }
              final notification = snapshot.docs[index].data();
              Widget seperatorDateWidget = const SizedBox.shrink();
              if (index == 0 ||
                  notification.createdAt.day !=
                      snapshot.docs[index - 1].data().createdAt.day) {
                seperatorDateWidget = Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    notification.createdAt
                        .timeAgo(ref.watch(appLanguageProvider).languageCode),
                    style: context.textTheme.bodyMedium!.copyWith(fontSize: 12),
                  ),
                );
              }
              return Column(
                children: [
                  seperatorDateWidget,
                  ProviderScope(
                    overrides: [
                      notificationProvider.overrideWithValue(notification),
                    ],
                    child: const NotificationWidget(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
