import 'package:flutter/material.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/admin_manage/admin_manage.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class AdminManageView extends ConsumerWidget {
  const AdminManageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin =
        ref.read(currentUserProfileProvider).accontType == AccontType.admin;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).AdminManageView_appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center, // Center items horizontally
          spacing: 20,
          runSpacing: 20,
          children: [
            GestureDetector(
              onTap: () => context.push(const DoctorsManageView()),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: Image.asset(
                      doctorsManageIcon,
                      width: 120,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    S.of(context).AdminManageView_doctorsText,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            if (isAdmin) ...[
              GestureDetector(
                onTap: () => context.push(const CitiesManageView()),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor,
                        ),
                      ),
                      child: Image.asset(
                        citiesManageIcon,
                        width: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      S.of(context).AdminManageView_citiesText,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.push(const CategoriesManageView()),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor,
                        ),
                      ),
                      child: Image.asset(
                        categoriesManageIcon,
                        width: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      S.of(context).AdminManageView_categoriesText,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor,
                        ),
                      ),
                      child: Image.asset(
                        postsManageIcon,
                        width: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      S.of(context).AdminManageView_postText,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
