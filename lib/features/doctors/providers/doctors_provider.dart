import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../profile/profile.dart';
import '../doctors.dart';

class DoctorsNotifier extends StateNotifier<List<UserModel>> {
  DoctorsNotifier(this._ref) : super([]);
  final Ref _ref;
  Future<List<UserModel>> getDoctorsList({bool activeOlny = true}) async {
    try {
      await Future.delayed(Duration.zero);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loadingType: LoadingTypes.inline);
      state = await _ref
          .read(doctorsRepoProvider)
          .getActiveDoctors(activeOlny: activeOlny);
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(
              loading: false, loadingType: LoadingTypes.inline);
    }
    return state;
  }
}

final doctorsProvider =
    StateNotifierProvider<DoctorsNotifier, List<UserModel>>((ref) {
  return DoctorsNotifier(ref);
});
