import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les locales françaises
  await initializeDateFormatting('fr_FR', null);
  
  // Configuration de la barre système
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AllsportsDeliveryApp());
}

class AllsportsDeliveryApp extends StatelessWidget {
  const AllsportsDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allsports Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E5FFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5FFF),
          primary: const Color(0xFF1E5FFF),
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}