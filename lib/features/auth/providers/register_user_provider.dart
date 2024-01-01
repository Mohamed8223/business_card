import 'package:clinigram_app/features/profile/data/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final registerUserProvider = StateProvider<UserModel>((ref) {
  return UserModel.init();
});

final isDoctorInEditViewProvider = StateProvider<bool>((ref) {
  return true;
});

final isClinicOwnerInEditViewProvider = StateProvider<bool>((ref) {
  return true;
});
