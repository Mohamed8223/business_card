import 'package:clinigram_app/feature_switches.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/admin_manage/data/models/city_model.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/core/models/db_string.dart';

final selectedCityProvider = StateProvider.autoDispose<CityModel?>((ref) {
  if (FeatureSwitches.searchV2 == true) {
    return null;
  }

  final userCity = ref.read(currentUserProfileProvider).cityModel;
  return userCity;
});
final selectedMainCategoryProvider =
    StateProvider.autoDispose<CategoryModel?>((ref) {
  return null;
});
final selectedSubCategoryProvider =
    StateProvider.autoDispose<CategoryModel?>((ref) {
  return null;
});

final selectedInsuranceProvider = StateProvider.autoDispose<DBString?>((ref) {
  return null;
});

final selectedDoctorAgreementsProvider =
    StateProvider.autoDispose<DBString?>((ref) {
  return null;
});

final selectedGenderProvider = StateProvider.autoDispose<DBString?>((ref) {
  return null;
});

final selectedLanguageProvider = StateProvider.autoDispose<DBString?>((ref) {
  return null;
});

final selectedSpecialityProvider = StateProvider.autoDispose<DBString?>((ref) {
  return null;
});

// online
final selectedOnlineProvider = StateProvider.autoDispose<DBString?>((ref) {
  return null;
});
class SelectedDistanceState extends StateNotifier<double?>{
  SelectedDistanceState():super(null);
  double? distance;
  change(double? value){
    state=value;
    distance=value;
  }
}
final selectedDistanceProvider = StateNotifierProvider<SelectedDistanceState,double?>((ref) {
  return SelectedDistanceState();
});
