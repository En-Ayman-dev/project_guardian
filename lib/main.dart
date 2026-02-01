import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_bloc_observer.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'l10n/app_localizations.dart';

bool _firestoreConfigured = false;

Future<void> _configureFirestoreOnce() async {
  if (_firestoreConfigured) return;
  _firestoreConfigured = true;

  final fs = FirebaseFirestore.instance;
  fs.settings = const Settings(
    persistenceEnabled: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _configureFirestoreOnce();
  await configureDependencies();

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Project Guardian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,

      // ✅ Localization (الآن تُبنى أولًا)
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      // ✅ Bloc بعد اكتمال MaterialApp و Localization
      builder: (context, child) {
        return BlocProvider(
          create: (_) =>
              getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
          child: child!,
        );
      },
    );
  } 
}
