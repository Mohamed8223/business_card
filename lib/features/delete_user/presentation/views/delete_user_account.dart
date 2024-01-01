import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/providers/auth_provider.dart';

class DeleteUserAccount extends ConsumerWidget {
  const DeleteUserAccount({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).DeleteUserAccount_delete_account),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).DeleteUserAccount_consequences,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(children: [
              const Text(
                "\u2022",
                style: TextStyle(fontSize: 30),
              ), //bullet text
              const SizedBox(
                width: 10,
              ), //space between bullet and text
              Expanded(
                child: Text(
                  S.of(context).DeleteUserAccount_consequences_description,
                ), //text
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(children: [
              const Text(
                "\u2022",
                style: TextStyle(fontSize: 30),
              ), //bullet text
              const SizedBox(
                width: 10,
              ), //space between bullet and text
              Expanded(
                child: Text(
                  S.of(context).DeleteUserAccount_youCant_add,
                ), //text
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(children: [
              const Text(
                "\u2022",
                style: TextStyle(fontSize: 30),
              ), //bullet text
              const SizedBox(
                width: 10,
              ), //space between bullet and text
              Expanded(
                child: Text(S.of(context).DeleteUserAccount_youCant_see), //text
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "\u2022",
                style: TextStyle(fontSize: 30),
              ), //bullet text
              const SizedBox(
                width: 10,
              ), //space between bullet and text
              Expanded(
                child: Text(
                  S.of(context).DeleteUserAccount_youCan_see_message,
                ), //text
              )
            ]),
            const Spacer(),
            ClinigramButton(
              onPressed: () {
                _dialogBuilder(context, ref);
                // FirebaseAuth.instance.currentUser!.delete();
                // ref.read(authProvider.notifier).logout();
              },
              child: Text(
                S.of(context).DeleteUserAccount_delete_account,
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, WidgetRef ref) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).DeleteUserAccount_delete_account_process),
          content: Text(
            S.of(context).DeleteUserAccount_delete_account_message,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                S.of(context).DeleteUserAccount_delete_account,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await ref.read(authProvider.notifier).deleteUser();
                await ref.read(authProvider.notifier).logout();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                  S.of(context).DeleteUserAccount_delete_account_cancelation),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
