import 'package:flutter/material.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/services.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  _TermsAndConditionsViewState createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  late Future<String> privacyPolicyContent;

  @override
  void initState() {
    super.initState();
    privacyPolicyContent = fetchPrivacyPolicy();
  }

  Future<String> fetchPrivacyPolicy() async {
    return await rootBundle
        .loadString('assets/policy/TermsAndConditionsEnglish.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Terms_and_conditions),
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
