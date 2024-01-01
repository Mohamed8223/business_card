import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/search/doctors_filter_tpe.dart';
import 'package:clinigram_app/features/search/presentation/widgets/strings_chips_list.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../clinics/presentation/views/clinics_layout.dart';
import '../../search.dart';
import '../widgets/distance_filter.dart';

class CustomSearchViewV2 extends StatefulWidget {
  @override
  _CustomSearchViewV2State createState() => _CustomSearchViewV2State();
}

class _CustomSearchViewV2State extends State<CustomSearchViewV2> {
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).CustomSearchView_Custom_Search),
            ),
            body: Consumer(builder: (context, ref, child) {
              if (!isInitialized) {
                isInitialized = true;
                Future.microtask(() => ref
                    .read(customSearchProvider.notifier)
                    .performCustomSearch());
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFilterButtons(context),
                    const SizedBox(height: 20),
                    TabBar(tabs: [
                      Tab(
                        text: S.of(context).CustomSearchResultsView_Doctors,
                      ),
                      Tab(
                        text: 'العيادات', //TODO to localization
                      ),
                    ]),
                    Consumer(builder: (context, ref, child) {
                      initializeListeners(ref);

                      // perform search on load
                      return const Expanded(
                        child: TabBarView(
                          children: [
                            DocotrsSearchReslutView(),
                            ClinicsLayout(isForDoctor: false, doctorId: ''),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            })));
  }

  SizedBox buildFilterButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // buildButton(
          //     context, DoctorsFilterType.location, Icons.filter_list,
          //     width: 160),
          // const SizedBox(width: 10),
          // buildButton(context, DoctorsFilterType.speciality,
          //     Icons.medical_services,
          //     width: 160),
          // const SizedBox(width: 10),
          buildButton(context, DoctorsFilterType.city, Icons.location_city),
          const SizedBox(width: 10),
          buildButton(context, DoctorsFilterType.service, Icons.category,
              width: 160),
          const SizedBox(width: 10),
          buildButton(context, DoctorsFilterType.insurance, Icons.money,
              width: 160),
          const SizedBox(width: 10),
          buildButton(context, DoctorsFilterType.hospital, Icons.home,
              width: 160),
          const SizedBox(width: 10),
          buildButton(context, DoctorsFilterType.gender, Icons.filter_list),
          const SizedBox(width: 10),
          buildButton(
              context, DoctorsFilterType.distance, Icons.social_distance,
              width: 160),
          //const SizedBox(width: 10),
          //buildButton(context, DoctorsFilterType.language, Icons.language,
          //    width: 160),
        ],
      ),
    );
  }

  void initializeListeners(WidgetRef ref) {
    ref.listen(selectedCityProvider, (prevSelectedCity, nextSelectedCity) {
      if (prevSelectedCity != nextSelectedCity) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedMainCategoryProvider,
        (prevSelectedMainCategory, nextSelectedMainCategory) {
      if (prevSelectedMainCategory != nextSelectedMainCategory) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedSubCategoryProvider,
        (prevSelectedSubCategory, nextSelectedSubCategory) {
      if (prevSelectedSubCategory != nextSelectedSubCategory) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedSpecialityProvider,
        (prevSelectedSpeciality, nextSelectedSpeciality) {
      if (prevSelectedSpeciality != nextSelectedSpeciality) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedInsuranceProvider,
        (prevSelectedInsurance, nextSelectedInsurance) {
      if (prevSelectedInsurance != nextSelectedInsurance) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedDoctorAgreementsProvider,
        (prevSelectedHospitalAgreements, nextSelectedHospitalAgreements) {
      if (prevSelectedHospitalAgreements != nextSelectedHospitalAgreements) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedGenderProvider,
        (prevSelectedGender, nextSelectedGender) {
      if (prevSelectedGender != nextSelectedGender) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedLanguageProvider,
        (prevSelectedLanguage, nextSelectedLanguage) {
      if (prevSelectedLanguage != nextSelectedLanguage) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });

    ref.listen(selectedOnlineProvider,
        (prevSelectedOnline, nextSelectedOnline) {
      if (prevSelectedOnline != nextSelectedOnline) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });
    ref.listen(selectedDistanceProvider, (prev, next) {
      if (prev != next) {
        ref.read(customSearchProvider.notifier).performCustomSearch();
      }
    });
  }

  Widget buildButton(BuildContext context, String filterType, IconData icon,
      {double width = 120}) {
    return Consumer(builder: (context, ref, child) {
      final filterSelected = isFilterSelected(ref, filterType);
      final borderColor = filterSelected ? secondryColor : separatorGray;
      final iconColor = filterSelected ? secondryColor : Colors.black;

      final text = getFilterDisplayText(filterType);

      return SizedBox(
        width: width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _showFilterOptions(context, filterType),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      );
    });
  }

  void resetFilterSelection(WidgetRef ref, String filterType) {
    if (filterType == DoctorsFilterType.speciality) {
      ref.read(selectedSpecialityProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.city) {
      ref.read(selectedCityProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.service) {
      ref.read(selectedMainCategoryProvider.notifier).update((state) => null);
      ref.read(selectedSubCategoryProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.insurance) {
      ref.read(selectedInsuranceProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.hospital) {
      ref
          .read(selectedDoctorAgreementsProvider.notifier)
          .update((state) => null);
    } else if (filterType == DoctorsFilterType.gender) {
      ref.read(selectedGenderProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.language) {
      ref.read(selectedLanguageProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.onlineService) {
      ref.read(selectedOnlineProvider.notifier).update((state) => null);
    } else if (filterType == DoctorsFilterType.distance) {
      ref.read(selectedDistanceProvider.notifier).change(null);
    }
  }

  bool isFilterSelected(WidgetRef ref, String filterType) {
    if (filterType == DoctorsFilterType.speciality) {
      return ref.watch(selectedSpecialityProvider) != null;
    } else if (filterType == DoctorsFilterType.city) {
      return ref.watch(selectedCityProvider) != null;
    } else if (filterType == DoctorsFilterType.service) {
      return ref.watch(selectedMainCategoryProvider) != null;
    } else if (filterType == DoctorsFilterType.gender) {
      return ref.watch(selectedGenderProvider) != null;
    } else if (filterType == DoctorsFilterType.insurance) {
      return ref.watch(selectedInsuranceProvider) != null;
    } else if (filterType == DoctorsFilterType.hospital) {
      return ref.watch(selectedDoctorAgreementsProvider) != null;
    } else if (filterType == DoctorsFilterType.language) {
      return ref.watch(selectedLanguageProvider) != null;
    } else if (filterType == DoctorsFilterType.onlineService) {
      return ref.watch(selectedOnlineProvider) != null;
    } else if (filterType == DoctorsFilterType.distance) {
      return ref.watch(selectedDistanceProvider) != null;
    }

    return false;
  }

  String getFilterDisplayText(String filterType) {
    switch (filterType) {
      case DoctorsFilterType.speciality:
        return S.current.DoctorInfoStepper_Specializations;
      case DoctorsFilterType.city:
        return S.current.CityDropDown_your_city;
      case DoctorsFilterType.service:
        return S.current.DoctorInfoStepper_Services;
      case DoctorsFilterType.insurance:
        return S.current.DoctorInfoStepper_Insurance;
      case DoctorsFilterType.hospital:
        return S.current.DoctorInfoStepper_Agreements;
      case DoctorsFilterType.location:
        return S.current.CitiesChipsList_Region;
      case DoctorsFilterType.gender:
        return S.current.GenderSelector_gender;
      case DoctorsFilterType.language:
        return S.current.Language;
      case DoctorsFilterType.onlineService:
        return S.current.Online;
      case DoctorsFilterType.distance:
        return 'المسافة';
      default:
        return ""; // Fallback if no filter type matches.
    }
  }

  void _showFilterOptions(BuildContext context, String filterType) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      constraints: const BoxConstraints(minHeight: 400),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag indicator
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),

                // Space
                const SizedBox(height: 10),

                // Modal dialog title and reset button
                Row(
                  children: [
                    // Filter Category Title
                    Text(
                      getFilterDisplayText(filterType),
                      style: const TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    // Reset Button
                    Consumer(builder: (context, ref, child) {
                      final filterSelected = isFilterSelected(ref, filterType);
                      final resetColor =
                          filterSelected ? secondryColor : separatorGray;
                      return TextButton(
                          onPressed: () {
                            resetFilterSelection(ref, filterType);
                          },
                          child: Text("Reset",
                              style: TextStyle(color: resetColor)));
                    })
                  ],
                ),

                // Space
                const SizedBox(height: 10),

                // Modal dialog content
                buildFilterModal(filterType, S.of(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFilterModal(String filterType, S localizationContext) {
    switch (filterType) {
      case DoctorsFilterType.city:
        return const CitiesChipsList();
      case DoctorsFilterType.service:
        return const CategoriesChipsList();
      case DoctorsFilterType.speciality:
        return const CategoriesChipsList(); // TODO: speciality=true
      case DoctorsFilterType.insurance:
        return StringsChipsList(
            DoctorsFilterValues.GetAvailableInsuranceServices(
                localizationContext),
            selectedInsuranceProvider);
      case DoctorsFilterType.hospital:
        return StringsChipsList(
            DoctorsFilterValues.getAvailableDoctorAgreements(
                localizationContext),
            selectedDoctorAgreementsProvider);
      case DoctorsFilterType.location:
        return Container(); // TODO: implement
      case DoctorsFilterType.gender:
        return StringsChipsList(
            DoctorsFilterValues.GetAvailableGenders(localizationContext),
            selectedGenderProvider);
      case DoctorsFilterType.language:
        return StringsChipsList(
            DoctorsFilterValues.GetAvailableLanguages(localizationContext),
            selectedLanguageProvider);
      case DoctorsFilterType.onlineService:
        return StringsChipsList(
            DoctorsFilterValues.GetAvailableOnlineServices(localizationContext),
            selectedOnlineProvider);
      case DoctorsFilterType.distance:
        return const DistanceFilter();
      default:
        return Container();
    }
  }
}
