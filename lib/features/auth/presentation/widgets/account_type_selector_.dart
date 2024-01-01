import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class AccountTypeSelector extends ConsumerStatefulWidget {
  const AccountTypeSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends ConsumerState<AccountTypeSelector> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(accountTypeProvider.notifier).state = AccontType.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountType = ref.watch(accountTypeProvider);
    final isUser = accountType == AccontType.user;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                ref.read(accountTypeProvider.notifier).state = AccontType.user;
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isUser ? context.theme.colorScheme.primary : Colors.white,
                  border: Border.all(
                    color: isUser
                        ? context.theme.colorScheme.primary
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset(
                            userIcon,
                            width: 80,
                            height: 80,
                            color: isUser ? Colors.white : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            S.of(context).AccountTypeSelector_user,
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    isUser
                        ? const Positioned(
                            left: 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                ref.read(accountTypeProvider.notifier).state =
                    AccontType.doctor;
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: !isUser
                      ? context.theme.colorScheme.primary
                      : Colors.white,
                  border: Border.all(
                    color: !isUser
                        ? context.theme.colorScheme.primary
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset(
                            doctorIcon,
                            width: 80,
                            height: 80,
                            color: !isUser ? Colors.white : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            S.of(context).AccountTypeSelector_doctor,
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: !isUser ? Colors.white : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    !isUser
                        ? const Positioned(
                            left: 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
