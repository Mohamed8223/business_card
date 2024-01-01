import 'dart:io';

import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/core.dart';

class ClinicsRepo {
  ClinicsRepo(this._ref);

  final Ref _ref;
  final _clinicCollection =
      FirebaseFirestore.instance.collection(clinicsCollection);

  Future<List<ClinicModel>> getClinicsOwnedByUser(String userId) async {
    List<ClinicModel> clinics = [];
    try {
      final results = await _clinicCollection
          .where('owner_ids', arrayContains: userId)
          .get();
      if (results.docs.isNotEmpty) {
        for (var element in results.docs) {
          Map<String, dynamic> json = element.data();
          GeoPoint? location = json['location'];
          json.remove('location');
          ClinicModel clinicModel = ClinicModel.fromJson(json);
          clinicModel =
              clinicModel.copyWith(id: element.id, location: location);
          clinics.add(clinicModel);
        }
      }
      // ignore: nullable_type_in_catch_clause
    } catch (e) {
      printDebug(e.toString());
    }
    return clinics;
  }

  Future<List<ClinicModel>> getClinicsWhereUserIsStaff(String userId) async {
    List<ClinicModel> clinics = [];
    try {
      final results = await _clinicCollection
          .where('staff_ids', arrayContains: userId)
          .get();
      if (results.docs.isNotEmpty) {
        for (var element in results.docs) {
          Map<String, dynamic> json = element.data();
          GeoPoint? location = json['location'];
          json.remove('location');
          ClinicModel clinicModel = ClinicModel.fromJson(json);
          clinicModel =
              clinicModel.copyWith(id: element.id, location: location);
          clinics.add(clinicModel);
        }
      }
      // ignore: nullable_type_in_catch_clause
    } catch (e) {
      printDebug(e.toString());
    }
    return clinics;
  }

  Future<List<ClinicModel>> getClinicsInTheCity(String cityNameEn) async {
    List<ClinicModel> clinics = [];
    try {
      final results = await _clinicCollection
          .where('city_model.name_en', isEqualTo: cityNameEn)
          .get();
      if (results.docs.isNotEmpty) {
        for (var element in results.docs) {
          Map<String, dynamic> json = element.data();
          GeoPoint? location = json['location'];
          json.remove('location');
          ClinicModel clinicModel = ClinicModel.fromJson(json);
          clinicModel =
              clinicModel.copyWith(id: element.id, location: location);
          clinics.add(clinicModel);
        }
      }
      // ignore: nullable_type_in_catch_clause
    } catch (e) {
      printDebug(e.toString());
    }
    return clinics;
  }

  Future<ClinicModel?> addClinic(ClinicModel clinic, XFile? image) async {
    try {
      String url = '';
      if (image != null) {
        url = await uploadXFileToFirebase(image, clinicsCoversCollection);
      }
      Map<String, dynamic> json = clinic.toJson();
      json['location'] = clinic.location;
      json['image_url'] = url;
      DocumentReference clinicDoc = await _clinicCollection.add(json);
      var newClinic = clinic.copyWith(id: clinicDoc.id, imageUrl: url);

      return newClinic;
    } catch (e) {
      printDebug(e.toString());
    }
    return null;
  }

  Future<ClinicModel?> updateClinic(ClinicModel clinic, XFile? image) async {
    try {
      ClinicModel newClinic = clinic;
      String url = clinic.imageUrl;
      if (image != null) {
        url = await uploadXFileToFirebase(image, clinicsCoversCollection);
        newClinic = newClinic.copyWith(imageUrl: url);
      }
      Map<String, dynamic> json = clinic.toJson();
      json['location'] = clinic.location;
      json['image_url'] = url;
      await _clinicCollection.doc(clinic.id).update(json);

      return newClinic;
    } catch (e) {
      printDebug(e.toString());
    }
    return null;
  }

  Future<bool> followClinic(ClinicModel clinic, String userId) async {
    try {
      await _clinicCollection.doc(clinic.id).update({
        'followers': FieldValue.arrayUnion([userId])
      });

      return true;
    } catch (e) {
      printDebug(e.toString());
    }
    return false;
  }

  Future<bool> unfollowClinic(ClinicModel clinic, String userId) async {
    try {
      await _clinicCollection.doc(clinic.id).update({
        'followers': FieldValue.arrayRemove([userId])
      });
      return true;
    } catch (e) {
      printDebug(e.toString());
    }
    return false;
  }

  // Clinic rating and reviews: addRatingAndComment
  Future<bool> addRatingAndComment(String clinicId, RatingModel rating) async {
    try {
      await _clinicCollection
          .doc(clinicId)
          .collection('ratings')
          .doc() // Optionally, you can generate a unique rating ID
          .set(rating.toDocument());

      return true;
    } catch (e) {
      printDebug(e.toString());
    }
    return false;
  }

  Future<List<RatingModel>> getRatingsForClinic(String clinicId) async {
    List<RatingModel> ratings = [];
    try {
      final ratingsSnapshot =
          await _clinicCollection.doc(clinicId).collection('ratings').get();

      return ratingsSnapshot.docs.map((doc) {
        return RatingModel.fromDocument(doc.data());
      }).toList();
    } catch (e) {
      printDebug(e.toString());
    }
    return ratings;
  }

  Future<int> getRatingsLengthForClinic(String clinicId) async {
    try {
      final ratingsSnapshot =
          await _clinicCollection.doc(clinicId).collection('ratings').get();

      return ratingsSnapshot.docs.length;
    } catch (e) {
      printDebug(e.toString());
    }
    return 0;
  }

  Future<bool> hasUserRated(String clinicId, String userId) async {
    try {
      final querySnapshot = await _clinicCollection
          .doc(clinicId)
          .collection('ratings')
          .where('user_id', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      printDebug(e.toString());
    }
    return false;
  }

  Future<bool> deleteClinic(ClinicModel clinic) async {
    try {
      await _clinicCollection.doc(clinic.id).delete();
      return true;
    } catch (e) {
      printDebug(e.toString());
    }
    return false;
  }
}

final clinicsRepoProvider = Provider<ClinicsRepo>((ref) {
  return ClinicsRepo(ref);
});
