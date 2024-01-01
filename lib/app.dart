import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_commands_bar.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/core.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Clinicate'),
          ),
          body:const App(),
        ),
      ),
    );
  }
}

class App extends ConsumerWidget {
  const App({Key? key});

  void _listenToRequestResponse(WidgetRef ref) {
    ref.listen(
      requestResponseProvider,
      (_, state) {
        state.whenOrNull(
          loading: (loading, type) {
            if (loading && type == LoadingTypes.daialog) {
              ref.watch(navigatorKeyProvider).context?.showLoadingOverlay();
            } else if (!loading && type == LoadingTypes.daialog) {
              ref.watch(navigatorKeyProvider).context?.pop();
            }
          },
          error: (message, addtionalData) {
            ref.watch(navigatorKeyProvider).context?.showSnackbarError(message);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(requestResponseProvider.notifier);
    _listenToRequestResponse(ref);

    // Check if the app is running on the web using kIsWeb

    // Check if the app is running on the web using kIsWeb
    bool isWeb = kIsWeb;
    final textDirection =
        ref.watch(appLanguageProvider) == const Locale('ar') ||
                ref.watch(appLanguageProvider) == const Locale('he')
            ? TextDirection.rtl
            : TextDirection.ltr;
    return ProviderScope(
      child: MaterialApp(
        navigatorKey: ref.watch(navigatorKeyProvider).navigatorKey,
        builder: (context, child) => Directionality(
          textDirection: textDirection,
          child: _Unfocus(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWeb
                      ? WebWidth
                      : double.infinity, // Adjust the maximum width as needed
                ),
                child: child!, // Replace with your actual app content widget
              ),
            ),
          ),
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: ref.watch(appLanguageProvider),
        supportedLocales: S.delegate.supportedLocales,
        theme: appTheme,
        home: const SplashView(),
      ),
    );
  }
}

class _Unfocus extends StatelessWidget {
  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
