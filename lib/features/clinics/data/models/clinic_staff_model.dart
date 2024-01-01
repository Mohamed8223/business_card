import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic_staff_model.freezed.dart';
part 'clinic_staff_model.g.dart';

@freezed
class ClinicStaffModel with _$ClinicStaffModel {
  const ClinicStaffModel._();
  const factory ClinicStaffModel({
    @Default("") String personalName,
    @Default("") String doctorId,
    @Default(false) bool doctorApproved,
    @Default([]) List<CategoryModel> specialities,
  }) = _ClinicStaffModel;

  factory ClinicStaffModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicStaffModelFromJson(json);
}
