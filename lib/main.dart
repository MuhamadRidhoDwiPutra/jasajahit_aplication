import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/firebase_options.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'src/theme/theme_switcher.dart';
import 'src/page/splash_screen.dart';
import 'src/page/login_screen.dart';
import 'src/page/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart';
import 'src/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseBackgroundHandler,
  );

  // Print FCM token ke console
  FirebaseMessaging.instance.getToken().then((token) {
    print('🔥 FCM Token: $token');
    print('📱 Copy token ini untuk testing notifikasi');
  });

  runApp(
    OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi notifikasi
    NotificationService.initialize(context);

    // Setup NotificationProvider
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    notificationProvider.setupFirebaseMessaging(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Jasa Jahit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF8FBC8F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFFDE8500)),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          background: Color(0xFF111111),
          surface: Color(0xFF222222),
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF111111),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111111),
          iconTheme: IconThemeData(color: Color(0xFFDE8500)),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
