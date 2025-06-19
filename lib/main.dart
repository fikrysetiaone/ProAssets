// lib/main.dart

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import halaman login sebagai halaman utama
import 'package:proassets/screens/login_screen.dart';

<<<<<<< HEAD
=======
// Import halaman HomeScreen Anda
import 'package:proassets/home_screen.dart'; // Pastikan file ini ada

//For development or temporary use
import 'package:proassets/screens/assets/daftar_assets.dart';

// Jadikan fungsi main menjadi async untuk inisialisasi Firebase
>>>>>>> 528d17537e22e39ddd80fd6cee2519980d13e98f
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
    return MaterialApp(
<<<<<<< HEAD
      title: 'Pro Assets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Jost',
      ),
      // Halaman awal aplikasi adalah LoginPage
      home: const LoginPage(),
=======
      title: 'Pro Assets Login',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue),
      // Arahkan home ke LoginPage seperti semula
      home: const DaftarAset(),
>>>>>>> 528d17537e22e39ddd80fd6cee2519980d13e98f
      debugShowCheckedModeBanner: false,
    );
  }
}
//end of main.dart
