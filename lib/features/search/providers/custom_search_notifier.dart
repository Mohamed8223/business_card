import 'package:clinigram_app/features/search/providers/location_provider.dart';
import 'package:clinigram_app/features/search/search.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/search_results_model.dart';

class CustomSearchNotifier
    extends StateNotifier<AsyncValue<SearchResultsModel>> {
  CustomSearchNotifier(this._ref) : super(AsyncData(SearchResultsModel()));
  final Ref _ref;
  SearchResultsModel _tempSearchResult = SearchResultsModel();

  performCustomSearch() async {
    try {
      state = const AsyncLoading();
      final cityId = _ref.read(selectedCityProvider)?.id ?? '';
      final mainCategory = _ref.read(selectedMainCategoryProvider);
      final subCategory = _ref.read(selectedSubCategoryProvider);
      final insurance = _ref.read(selectedInsuranceProvider);
      var gender = _ref.read(selectedGenderProvider);
      final language = _ref.read(selectedLanguageProvider);
      final hospitalAgreements = _ref.read(selectedDoctorAgreementsProvider);
      final online = _ref.read(selectedOnlineProvider);
      final distance = _ref.read(selectedDistanceProvider);
      final location = _ref.watch(locationProvider);

      final postsResult = await _ref
          .read(searchRepoProvider)
          .postsCustomSearch(cityId, mainCategory, subCategory);

      final docotrsResult = await _ref
          .read(searchRepoProvider)
          .docotrsCustomSearch(
          cityId,
          false /* isActive */,
          mainCategory,
          subCategory,
          insurance?.value,
          hospitalAgreements?.value,
          gender?.value,
          language?.value,
          online?.value,
          distance,location);

      final clinicsResult = await _ref
          .read(searchRepoProvider)
          .clinicsCustomSearch(
          cityId: cityId,
          mainCategory: mainCategory,
          subCategory: subCategory,
          distance: distance,location: location);

      state = AsyncData(SearchResultsModel(
          posts: postsResult, users: docotrsResult, clinics: clinicsResult));

      _tempSearchResult = state.asData!.value;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // TODO: add other search types
  performDoctorsCustomSearch() async {
    try {
      state = const AsyncLoading();
      final cityId = _ref.read(selectedCityProvider)?.id ?? '';
      final mainCategory = _ref.read(selectedMainCategoryProvider);
      final subCategory = _ref.read(selectedSubCategoryProvider);
      final insurance = _ref.read(selectedInsuranceProvider);
      final gender = _ref.read(selectedGenderProvider);
      final language = _ref.read(selectedLanguageProvider);
      final hospitalAgreements = _ref.read(selectedDoctorAgreementsProvider);
      final online = _ref.read(selectedOnlineProvider);
      final distance = _ref.read(selectedDistanceProvider);
      final location = _ref.watch(locationProvider);


      final docotrsResult = await _ref
          .read(searchRepoProvider)
          .docotrsCustomSearch(
        cityId,
        false /* isActive */,
        mainCategory,
        subCategory,
        insurance?.value,
        hospitalAgreements?.value,
        gender?.value,
        language?.value,
        online?.value,
        distance,location,);

      final clinicsResult =
      await _ref.read(searchRepoProvider).clinicsCustomSearch(
        cityId: cityId,
        mainCategory: mainCategory,
        subCategory: subCategory,
        distance: distance,
        location:location,
      );

      state = AsyncData(_tempSearchResult.copyWith(
          users: docotrsResult, clinics: clinicsResult));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final customSearchProvider =
StateNotifierProvider<CustomSearchNotifier, AsyncValue<SearchResultsModel>>(
        (ref) {
      return CustomSearchNotifier(ref);
    });
