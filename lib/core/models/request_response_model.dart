import 'package:freezed_annotation/freezed_annotation.dart';

import '../core.dart';

part 'request_response_model.freezed.dart';

@freezed
class RequestResponseModel with _$RequestResponseModel {
  factory RequestResponseModel.loading({
    @Default(true) bool loading,
    @Default(LoadingTypes.daialog) LoadingTypes loadingType,
  }) = _Loading;
  factory RequestResponseModel.sucess({
    final String? message,
    final dynamic addtionalData,
  }) = _Sucess;
  factory RequestResponseModel.error({
    final String? message,
    final dynamic addtionalData,
  }) = _Error;
  factory RequestResponseModel.init() = _Init;
}
