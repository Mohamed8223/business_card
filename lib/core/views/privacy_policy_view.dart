import 'package:flutter/material.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  _PrivacyPolicyViewState createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  late Future<String> privacyPolicyContent;

  @override
  void initState() {
    super.initState();
    privacyPolicyContent = fetchPrivacyPolicy();
  }

  Future<String> fetchPrivacyPolicy() async {
    return await rootBundle.loadString('assets/policy/privacyPolicy.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PrivacyPolicyView_privacy_policy),
      ),
      body: FutureBuilder<String>(
        future: privacyPolicyContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? 'No data found'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
