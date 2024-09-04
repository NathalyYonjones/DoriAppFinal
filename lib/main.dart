import 'package:doriapp/firebase_options.dart';
import 'package:doriapp/pages/login_page.dart';
import 'package:doriapp/pages/registration_page.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Dori App',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('es', ''),
        ],
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.primaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 175.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/miditoys.png'),
                    width: 135,
                    height: 100,
                    fit: BoxFit.cover),
                const Image(
                    image: AssetImage('assets/dori.png'),
                    width: 350,
                    height: 150,
                    fit: BoxFit.cover),
                const SizedBox(height: 75.0),
                RoundButton(
                  text: "INICIAR SESIÓN",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                RoundButton(
                  text: "REGISTRARSE",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
