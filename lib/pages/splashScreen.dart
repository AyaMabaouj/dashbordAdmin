import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_app/pages/homePage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5, // Prend plus d'espace
              child: Center(
                child: Image.asset(
                  'assets/images/miel.png',
                  width: 400,
                  height: 350,
                ),
              ),
            ),
     Image.asset(
      'assets/images/bee2.png',  // Path to your custom bee image
      width: 50,  // Adjust width of the bee image
      height: 50, // Adjust height of the bee image
    ),
            const Text(
              'HoneyHive',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
             SizedBox(height: 10), // Espace entre les deux textes
           Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adds padding to the left and right
                child: Text(
                  'Welcome to HoneyHive, where we bring you the finest, purest honey straight from nature. Taste the sweetness and discover the benefits of honey in its most natural form.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center, // Centers the description
                ),
              ),
            const Spacer(), // Ajoute de l'espace avant le bouton
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
