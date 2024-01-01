import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final registerClinicProvider = StateProvider<ClinicModel>((ref) {
  return ClinicModel.init();
});

final registerClinicImageProvider = StateProvider<XFile?>((ref) {
  return null;
});

final registerClinicAgreementPageVisibleProvider = StateProvider<bool>((ref) {
  return false;
});
