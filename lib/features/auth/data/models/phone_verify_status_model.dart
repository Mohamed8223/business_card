import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verify_status_model.freezed.dart';

@freezed
class PhoneVerifyStatusModel with _$PhoneVerifyStatusModel {
  factory PhoneVerifyStatusModel.codeSent({
    required final String receivedID,
    required final String phone,
  }) = _CodeSent;
  factory PhoneVerifyStatusModel.codeVerified({
    required final bool isProfileCompleted,
  }) = _CodeVerified;
  factory PhoneVerifyStatusModel.error({
    final String? message,
    final dynamic addtionalData,
  }) = _Error;
  factory PhoneVerifyStatusModel.init({
    final String? message,
  }) = _Init;
}
