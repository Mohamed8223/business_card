import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/core/models/db_string.dart';

class DoctorsFilterType {
  static const String city = "City";
  static const String speciality = "Speciality";
  static const String service = "Service";
  static const String insurance = "Insurance";
  static const String hospital = "Hospital";
  static const String location = "Location";
  static const String gender = "Gender";
  static const String language = "Language";
  static const String onlineService = "OnlineService";
  static const String distance = "Distance";
}

class DoctorsFilterValues {
  static List<DBString> GetAvailableGenders(S localizationContext) {
    return [
      DBString(
          displayValue: localizationContext.GenderSelector_male, value: 'male'),
      DBString(
          displayValue: localizationContext.GenderSelector_female,
          value: 'female'),
    ];
  }

  static List<DBString> GetAvailableLanguages(S localizationContext) {
    return [
      DBString(value: 'english', displayValue: 'English'),
      DBString(value: 'arabic', displayValue: 'عربي'),
      DBString(value: 'hebrew', displayValue: 'עברית'),
      DBString(value: 'russian', displayValue: 'русский'),
    ];
  }

  static List<DBString> GetAvailableOnlineServices(S localizationContext) {
    return [
      DBString(
          displayValue: localizationContext.DoctorsManageView_yes,
          value: 'yes'),
      DBString(
          displayValue: localizationContext.DoctorsManageView_no, value: 'no'),
    ];
  }

  static List<DBString> GetAvailableInsuranceServices(S localizationContext) {
    return [
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Migdal,
          value: 'Migdal'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Phoenix,
          value: 'Phoenix'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Harel,
          value: 'Harel'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Menora,
          value: 'Menora'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Clal,
          value: 'Clal'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Dikla,
          value: 'Dikla'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Ayalon,
          value: 'Ayalon'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_IDI_Insurance,
          value: 'IDI Insurance'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Ilanot,
          value: 'Ilanot'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Eliahu,
          value: 'Eliahu'),
      DBString(
          displayValue: localizationContext
              .DoctorAgreementsWithInsuranceView_Agreements_Shirbit,
          value: 'Shirbit'),
    ];
  }

  static List<DBString> getAvailableDoctorAgreements(S localizationContext) {
    return [
      DBString(
          displayValue: localizationContext.DoctorAgreementsView_Clalit,
          value: 'Clalit'),
      DBString(
          displayValue: localizationContext.DoctorAgreementsView_Maccabi,
          value: 'Maccabi'),
      DBString(
          displayValue: localizationContext.DoctorAgreementsView_Leumit,
          value: 'Leumit'),
      DBString(
          displayValue: localizationContext.DoctorAgreementsView_Meuhedit,
          value: 'Meuhidit'),
    ];
  }
}
