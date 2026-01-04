import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart'; // سيتم توليده بواسطة flutterfire
import 'core/di/injection_container.dart';
import 'core/utils/app_bloc_observer.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/presentation/manager/auth_bloc/auth_bloc.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Dependency Injection
  await configureDependencies();

  // 3. Set Bloc Observer
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()), // ابدأ الفحص فوراً
      child: MaterialApp.router(
      title: 'Project Guardian',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      
      // Routing
      routerConfig: goRouter,
      
      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic (سنضيفه لاحقاً)
      ],
  ),
    );
  }
}