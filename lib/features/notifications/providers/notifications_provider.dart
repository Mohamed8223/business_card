import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, Query;
import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider;

import '../../../core/core.dart';
import '../../profile/profile.dart';
import '../data/models/models.dart';

final notificationsRefProvider = Provider.autoDispose<Query<NotificationModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    final currentUserId = ref.watch(currentUserProfileProvider).id;
    return db
        .collection(notificationsCollection)
        .where('receiver_id', isEqualTo: currentUserId)
        .orderBy('created_at', descending: true)
        .withConverter<NotificationModel>(
          fromFirestore: (snapshot, _) {
            return NotificationModel.fromDocument(snapshot);
          },
          toFirestore: (state, __) => state.toJson(),
        );
  },
);
