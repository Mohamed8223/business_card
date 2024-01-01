import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final notification = ref.watch(notificationProvider);
    return Card(
      elevation: 0.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: CircleAvatar(
          backgroundImage: notification.senderAvatar.isEmpty
              ? const AssetImage(userProfileImage) as ImageProvider
              : CachedNetworkImageProvider(notification.senderAvatar),
        ),
        title: Text(notification.body),
        subtitle: Text(
          notification.createdAt
              .timeFormat(ref.watch(appLanguageProvider).languageCode),
          style: context.textTheme.bodySmall!.copyWith(
            fontSize: 10,
            color: secondryColor,
          ),
        ),
      ),
    );
  }
}
