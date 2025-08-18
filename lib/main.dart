import 'package:cars/auth/auth_state.dart';

import 'package:cars/pages/landing_page.dart';
import 'package:cars/pages/newhome_page.dart';
import 'package:cars/pages/settings_page.dart';
import 'package:cars/pages/sign_up_page.dart';
import 'package:cars/pages/user_info_page.dart';
import 'package:cars/pages/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: Color(0xFF333333),);
        }
        return TextStyle(color: Colors.grey);
      }),
    ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingPage(),
        '/signup': (context) => const SignUpPage(),
        //'/homepage': (context) => const HomePage(),
        '/authstate': (context) => const AuthState(),
        '/settings': (context) => const SettingsPage(),
        '/newhomepage': (context) => const NewhomePage(),
        '/userinfo': (context) => const UserInfoPage(),
        '/verify-email': (context) => const VerifyEmailPage()
      },
    );
  }
}
