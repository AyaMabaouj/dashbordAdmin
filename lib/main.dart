import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miel_app/pages/admin_dashboard.dart';
import 'package:miel_app/pages/login_web.dart';
import 'package:miel_app/pages/register_web.dart';
import 'package:miel_app/pages/splashScreen.dart';

void main() {
    Get.testMode = true; // Mode test pour GetX

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Ajout de 'const'

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Honey Application Admin Dashboard',
           theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 233, 157, 42), // Définit l'orange comme couleur principale
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: const Color.fromARGB(255, 243, 163, 43), // Applique l'orange partout
                  secondary: Colors.amber, // Une couleur secondaire proche de l'orange
                ),
                scaffoldBackgroundColor: Colors.white, // Fond blanc
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(214, 255, 181, 45), // Orange vif
                  iconTheme: IconThemeData(color: Colors.white), // Icônes en blanc pour contraste
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20,),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                buttonTheme: const ButtonThemeData(
                  buttonColor: Colors.orange, // Boutons orange
                  textTheme: ButtonTextTheme.primary, // Texte des boutons en blanc
                ),
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.black), // Texte en noir
                  bodyMedium: TextStyle(color: Colors.black),
                  titleLarge: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold), // Titres orange et gras
                ),
                cardColor: Colors.white, // Fond des cartes en blanc
              ),


      //home:  SplashScreen(),
    home:  DashboardScreen(),
     // home:  LoginPage(),
    );
  }
}
