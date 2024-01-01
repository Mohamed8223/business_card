import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinics_layout.dart';
import 'package:clinigram_app/features/posts/posts.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:clinigram_app/features/search/search.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomSearchResultsView extends ConsumerWidget {
  const CustomSearchResultsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).CustomSearchResultsView_Search_Results),
          bottom: TabBar(tabs: [
            const Tab(
              text: 'العيادات', //TODO to localization
            ),
            Tab(
              text: S.of(context).CustomSearchResultsView_Doctors,
            ),
            Tab(
              text: S.of(context).CustomSearchResultsView_Posts,
            ),
          ]),
        ),
        body: const TabBarView(
          children: [
            ClinicsLayout(isForDoctor: false, doctorId: ''),
            DocotrsSearchReslutView(),
            PostsSearchReslutView(),
          ],
        ),
      ),
    );
  }
}

class PostsSearchReslutView extends ConsumerWidget {
  const PostsSearchReslutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchReslutsAsync = ref.watch(customSearchProvider);

    return searchReslutsAsync.when(
        data: (state) => state.posts.isEmpty
            ? Center(
                child: Text(S
                    .of(context)
                    .CustomSearchResultsView_No_matching_search_results),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: state.posts.length,
                itemBuilder: (context, index) => PostWidget(
                    postModel: state.posts[index], postsHost: PostsHost.search),
              ),
        error: (_, __) => CustomErrorWidget(onTap: () {}),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}

class DocotrsSearchReslutView extends ConsumerWidget {
  const DocotrsSearchReslutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchReslutsAsync = ref.watch(customSearchProvider);

    return searchReslutsAsync.when(
        data: (state) => state.users.isEmpty
            ? Center(
                child: Text(S
                    .of(context)
                    .CustomSearchResultsView_No_matching_search_results),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: state.users.length,
                itemBuilder: (context, index) => DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.27),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    onTap: () => context.push(
                        OtherUserProfileView(userId: state.users[index].id)),
                    leading: CircleAvatar(
                      backgroundImage: state.users[index].imageUrl.isEmpty
                          ? getDefaultProfilePicByAccountType(
                              state.users[index].accontType) as ImageProvider
                          : CachedNetworkImageProvider(
                              state.users[index].imageUrl),
                    ),
                    title: Text(state.users[index].getLocalizedFullName(ref)),
                    subtitle: Text(
                      extraxtDoctorSpecialists(
                          state.users[index].specialists, ref),
                      style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                  ),
                ),
              ),
        error: (_, __) => CustomErrorWidget(onTap: () {}),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
