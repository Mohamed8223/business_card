import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/posts/posts.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_results_model.freezed.dart';

@freezed
class SearchResultsModel with _$SearchResultsModel {
  factory SearchResultsModel({
    @Default([]) List<PostModel> posts,
    @Default([]) List<UserModel> users,
    @Default([]) List<ClinicModel> clinics,
  }) = _SearchResultsModel;
}
