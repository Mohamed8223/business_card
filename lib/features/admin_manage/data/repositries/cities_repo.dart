import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/city_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CitiesRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<CityModel> addCity(CityModel cityModel) async {
    final docRef = await _firebaseFirestore
        .collection(citiesCollection)
        .add(cityModel.toDocument());
    return cityModel.copyWith(id: docRef.id);
  }

  Future<CityModel> updateCity(CityModel cityModel) async {
    await _firebaseFirestore
        .collection(citiesCollection)
        .doc(cityModel.id)
        .update(cityModel.toDocument());
    return cityModel;
  }

  Future<List<CityModel>> getAllCities({bool activeOlny = true}) async {
    final List<CityModel> citiesList = [];

    final citiesSnapshots = await _firebaseFirestore
        .collection(citiesCollection)
        .orderBy('name_ar') // TODO
        .get();

    for (var cityMap in citiesSnapshots.docs) {
      final cityModel = CityModel.fromDocument(cityMap);
      citiesList.add(cityModel);
    }
    return citiesList;
  }
}

final citiesRepoProvider = Provider<CitiesRepo>((ref) {
  return CitiesRepo();
});
