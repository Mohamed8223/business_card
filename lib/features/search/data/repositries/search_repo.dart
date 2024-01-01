import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/posts/posts.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/distance_calculation.dart';

class SearchRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;

//TODO : pagination
  Future<List<PostModel>> postsCustomSearch(String cityId,
      CategoryModel? mainCategory, CategoryModel? subCategory) async {
    final List<PostModel> postsList = [];
    Query postsQuery = _firebaseFirestore.collection(postsCollection);

    if (cityId.isNotEmpty) {
      postsQuery = postsQuery.where('city_id', isEqualTo: cityId);
    }

    if (mainCategory != null) {
      postsQuery =
          postsQuery.where('main_category.id', isEqualTo: mainCategory.id);
    }

    if (subCategory != null) {
      postsQuery =
          postsQuery.where('sub_category.id', isEqualTo: subCategory.id);
    }

    final postsSnapshots = await postsQuery.limit(5).get();

    for (var postMap in postsSnapshots.docs) {
      DocumentReference userRef = postMap['user_model'];
      DocumentSnapshot userSnapshot = await userRef.get();
      final postMapData = postMap.data() as Map<String, dynamic>;
      postMapData.addAll({'id': postMap.id});
      postMapData.update('user_model', (value) => userSnapshot.data());
      final postModel = PostModel.fromJson(postMapData);
      postsList.add(postModel);
    }
    debugPrint(postsList.toString());
    return postsList;
  }

  Future<List<UserModel>> docotrsCustomSearch(
      String cityId,
      bool isActive,
      CategoryModel? mainCategory,
      CategoryModel? subCategory,
      String? insurance,
      String? hospitalAgreements,
      String? gender,
      String? language,
      String? online,
      double? distance,
      GeoPoint? location) async {
    final List<UserModel> doctorsList = [];
    Query doctorsQuery = _firebaseFirestore
        .collection(usersCollection)
        .where('accont_type', isEqualTo: AccontType.doctor.name);

    if (isActive) {
      // return active only
      doctorsQuery = doctorsQuery.where('is_active', isEqualTo: isActive);
    }

    if (cityId.isNotEmpty) {
      doctorsQuery = doctorsQuery.where('city_model.id', isEqualTo: cityId);
    }

    if (gender != null) {
      doctorsQuery =
          doctorsQuery.where('gender', isEqualTo: gender.toLowerCase());
    }

    if (language != null) {
      // TODO: Need to add language to the user model
      doctorsQuery = doctorsQuery.where('languages',
          arrayContains: language.toLowerCase());
    }

    if (online != null) {
      // TODO: Need to add online to the user model
      doctorsQuery =
          doctorsQuery.where('online_service', isEqualTo: online.toLowerCase());
    }

    if (hospitalAgreements != null) {
      // Do not lower case the hospitalAgreements name
      doctorsQuery = doctorsQuery.where('doctor_agreement',
          arrayContains: hospitalAgreements);
    }

    if (insurance != null) {
      // Do not lower case the insurance name
      doctorsQuery = doctorsQuery.where('agreements_with_insurance',
          arrayContains: insurance);
    }

    final doctorsSnapshots = await doctorsQuery.limit(100).get();
    for (var doctorMap in doctorsSnapshots.docs) {
      final doctorModel = UserModel.fromDocument(
          doctorMap as DocumentSnapshot<Map<String, dynamic>>);
      if (distance != null && location != null) {
        GeoPoint l, g;
        (l, g) = calculateLimitDistances(distance, location);
        if (doctorModel.cityModel != null &&
            doctorModel.cityModel!.cityLocation != null) {
          GeoPoint doctorLocation = doctorModel.cityModel!.cityLocation!;
          if (doctorLocation.latitude > l.latitude &&
              doctorLocation.latitude < g.latitude &&
              doctorLocation.longitude > l.longitude &&
              doctorLocation.longitude < g.longitude) {
            if (mainCategory != null) {
              if (doctorModel.specialists
                  .any((element) => element.id == mainCategory.id)) {
                if (subCategory != null) {
                  if (doctorModel.specialists.any((element) => element
                      .subCategories
                      .any((element) => element.id == subCategory.id))) {
                    doctorsList.add(doctorModel);
                  }
                  continue;
                }

                doctorsList.add(doctorModel);
              }
              continue;
            }
          } else {
            continue;
          }
        }
      }

      doctorsList.add(doctorModel);
    }
    return doctorsList;
  }

  Future<List<ClinicModel>> clinicsCustomSearch({
    String? cityId,
    double? distance,
    GeoPoint? location,
    CategoryModel? mainCategory,
    CategoryModel? subCategory,
  }) async {
    final List<ClinicModel> clinics = [];
    Query clinicsQuery = _firebaseFirestore.collection(clinicsCollection);

    if (cityId != null && cityId.isNotEmpty) {
      clinicsQuery = clinicsQuery.where('city_model.id', isEqualTo: cityId);
    }
    if (distance != null && location != null) {
      GeoPoint l, g;

      (l, g) = calculateLimitDistances(distance, location);

      clinicsQuery = clinicsQuery
          .where("location", isGreaterThan: l)
          .where("location", isLessThan: g);
    }

    final clinicsSnapshots = await clinicsQuery.limit(50).get();

    if (clinicsSnapshots.docs.isNotEmpty) {
      for (QueryDocumentSnapshot clinicMap in clinicsSnapshots.docs) {
        Map<String, dynamic> json = clinicMap.data() as Map<String, dynamic>;
        GeoPoint? location = json['location'];
        json.remove('location');
        ClinicModel clinicModel = ClinicModel.fromJson(json);
        clinicModel =
            clinicModel.copyWith(id: clinicMap.id, location: location);
        if (mainCategory != null) {
          if (clinicModel.specialists
              .any((element) => element.id == mainCategory.id)) {
            if (subCategory != null) {
              if (clinicModel.specialists.any((element) => element.subCategories
                  .any((element) => element.id == subCategory.id))) {
                clinics.add(clinicModel);
              }
              continue;
            }

            clinics.add(clinicModel);
          }
          continue;
        }
        clinics.add(clinicModel);
      }
    }
    return clinics;
  }
}

final searchRepoProvider = Provider<SearchRepo>((ref) {
  return SearchRepo();
});
