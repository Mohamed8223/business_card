import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/admin_manage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CitiesNotifier extends StateNotifier<AsyncValue<List<CityModel>>> {
  CitiesNotifier(this._ref) : super(const AsyncData([])) {}
  final Ref _ref;
  getCities() async {
    try {
      state = const AsyncLoading();
      final cities = await _ref.read(citiesRepoProvider).getAllCities();
      state = AsyncData(cities);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  addNewCity(CityModel cityModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      final city = await _ref.read(citiesRepoProvider).addCity(cityModel);
      state = AsyncData([city, ...state.value!]);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }

  updateCity(CityModel cityModel) async {
    try {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(),
          );
      final updatedCity =
          await _ref.read(citiesRepoProvider).updateCity(cityModel);
      state = AsyncData([
        for (var city in state.value!)
          if (city.id == updatedCity.id) updatedCity else city
      ]);
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.sucess(),
          );
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.error(),
          );
    } finally {
      _ref.read(requestResponseProvider.notifier).update(
            (state) => RequestResponseModel.loading(loading: false),
          );
    }
  }
}

final citiesProvider =
    StateNotifierProvider<CitiesNotifier, AsyncValue<List<CityModel>>>((ref) {
  return CitiesNotifier(ref);
});
