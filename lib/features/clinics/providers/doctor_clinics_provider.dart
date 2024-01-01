import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/clinic_model.dart';

class DoctorClinicsProvider
    extends StateNotifier<AsyncData<List<ClinicModel>>> {
  DoctorClinicsProvider(this._ref) : super(const AsyncData([]));
  final Ref _ref;
  List<ClinicModel> clinics = [];

  getClinics(String id) async {
    try {
      // state = AsyncLoading() as AsyncData<List<ClinicModel>>;
      clinics = await _ref.read(clinicsRepoProvider).getClinicsOwnedByUser(id);
      state = AsyncData(clinics);
    } catch (e) {
      // state = AsyncError(e, StackTrace.current) as AsyncData<List<ClinicModel>>;
    }
  }

  addClinic(ClinicModel clinicModel, XFile? image) async {
    try {
      // state = const AsyncLoading() as AsyncData<List<ClinicModel>>;
      ClinicModel? newClinic =
          await _ref.read(clinicsRepoProvider).addClinic(clinicModel, image);
      if (newClinic != null) {
        clinics.add(newClinic);
      }

      state = AsyncData(clinics);

      clinics = state.asData!.value;
    } catch (e) {
      // state = AsyncError(e, StackTrace.current) as AsyncData<List<ClinicModel>>;
    }
  }

  deleteClinic(ClinicModel clinicModel) async {
    bool result =
        await _ref.read(clinicsRepoProvider).deleteClinic(clinicModel);
    if (result) {
      clinics.remove(clinicModel);
    }
    state = AsyncData(clinics);
    clinics = state.asData!.value;
  }

  updateClinic(ClinicModel clinicModel, XFile? image) async {
    try {
      // state = const AsyncLoading() as AsyncData<List<ClinicModel>>;
      ClinicModel? result =
          await _ref.read(clinicsRepoProvider).updateClinic(clinicModel, image);
      if (result != null) {
        int index = clinics.indexWhere(
          (element) => element.id == clinicModel.id,
        );
        clinics[index] = result;
      }
      state = AsyncData(clinics);
      clinics = state.asData!.value;
    } catch (e) {
      // state = AsyncError(e, StackTrace.current) as AsyncData<List<ClinicModel>>;
    }
  }
}

final doctorClinicsProvider =
    StateNotifierProvider<DoctorClinicsProvider, AsyncValue<List<ClinicModel>>>(
        (ref) => DoctorClinicsProvider(ref));
