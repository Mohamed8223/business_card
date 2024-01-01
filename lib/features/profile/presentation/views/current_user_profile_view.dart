import 'package:clinigram_app/core/constants/keys_enums.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinics_screen.dart';
import 'package:clinigram_app/features/profile/presentation/widgets/doctor_card.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/presentation/views/translate_bottom.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../clinics/providers/doctor_clinics_provider.dart';

class CurrentUserProfileView extends ConsumerStatefulWidget {
  const CurrentUserProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentUserProfileViewState();
}

class _CurrentUserProfileViewState
    extends ConsumerState<CurrentUserProfileView> {
  late final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProfileProvider);
    ref.read(doctorClinicsProvider.notifier).getClinics(currentUser.id);

    // final specialistsList = currentUser.getSpecialistsByLanguage(
    //     currentUser.specialists, ref, CategoryType.specialist);
    //
    // final servicesList = currentUser.getSpecialistsByLanguage(
    //     currentUser.specialists, ref, CategoryType.service);
    //
    // final proffession =
    //     currentUser.getProffessionName(currentUser.specialists, ref) ?? '';

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(S.of(context).CurrentUserProfileView_profileTitle),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).Select_language),
                      content: const LanguageSelectionWidget(),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.language, // Change to the icon you prefer
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const ProfileBottomSheet(),
                );
              },
              icon: const Icon(
                Icons.more_vert_outlined,
              ),
            )
          ],
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
                child: DoctorCard(currentUser.id, IsmyProfile: true)),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            if (currentUser.accontType != AccontType.user)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    context.push(ClinicsScreen(doctorId: currentUser.id));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xff113c67),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'العيادات', //Todo to localization
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
                child: InfoColumn(currentUser.id, IsmyProfile: true)),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            //SliverToBoxAdapter(child: AddRate()),
            ProfilePostsList(
              userId: currentUser.id,
              scrollController: _scrollController,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            )
          ],
        ));
  }
}
