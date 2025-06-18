// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File hasil generate FlutterFire

// TODO: Import layar utama Anda nanti di sini

void main() async {
  // Pastikan Flutter siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
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
      title: 'ProAsset',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Untuk sementara, kita tampilkan halaman loading
      home: const Scaffold(
        body: Center(
          child: Text("Firebase Terhubung!"),
        ),
      ),
    );
  }
}