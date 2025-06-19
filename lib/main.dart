// lib/main.dart

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'dart:developer'; // Tetap digunakan untuk logging

// --- IMPORT BARU UNTUK FIREBASE ---
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk interaksi database nanti
import 'firebase_options.dart'; // File ini di-generate oleh flutterfire_cli

// --- IMPORT LAMA YANG DIHAPUS ---
// import 'package:http/http.dart' as http; // Tidak lagi digunakan
// import 'dart:convert'; // Tidak lagi digunakan

// Import halaman HomeScreen Anda
import 'package:proassets/home_screen.dart'; // Pastikan file ini ada

//For development or temporary use
import 'package:proassets/screens/assets/daftar_assets.dart';

// Jadikan fungsi main menjadi async untuk inisialisasi Firebase
void main() async {
  // Pastikan Flutter binding sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase sesuai platform (Android/iOS/Web)
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
      title: 'Pro Assets Login',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue),
      // Arahkan home ke LoginPage seperti semula
      home: const DaftarAset(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // State untuk menunjukkan proses loading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi _showAlertDialog dipertahankan sepenuhnya, sudah sangat bagus!
  void _showAlertDialog(
    String title,
    String message, {
    bool isSuccess = false,
  }) {
    Color dialogColor = isSuccess ? Colors.green : Colors.red;
    IconData dialogIcon = isSuccess ? Icons.check : Icons.close;
    String statusText = isSuccess ? 'SUCCESS!' : 'ERROR!';

    // Menggunakan context yang aman
    if (!mounted) return;
    final BuildContext currentContext = context;

    showDialog(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: dialogColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(dialogIcon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                statusText,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: dialogColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (isSuccess && mounted) {
                    Navigator.pushReplacement(
                      currentContext,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- FUNGSI LOGIN BARU DENGAN FIREBASE ---
  Future<void> _handleLogin() async {
    // Jika sedang dalam proses loading, jangan lakukan apa-apa
    if (_isLoading) return;

    setState(() {
      _isLoading = true; // Mulai loading
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlertDialog(
        'Login Gagal',
        'Email atau Password tidak boleh kosong.',
        isSuccess: false,
      );
      setState(() {
        _isLoading = false; // Hentikan loading
      });
      return;
    }

    try {
      // Menggunakan Firebase Authentication untuk login
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Jika login berhasil, userCredential akan berisi data pengguna
      if (userCredential.user != null) {
        // Karena nama tidak lagi didapat dari API, kita bisa ambil dari data Firestore
        // atau fallback ke email jika belum ada.
        final user = userCredential.user!;
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userName =
            doc.exists ? (doc.data()?['name'] ?? user.email) : user.email;

        _showAlertDialog(
          'Login Berhasil',
          'Selamat Datang di Pro Assets, $userName!',
          isSuccess: true,
        );
        log('Login successful: UID ${user.uid}', name: 'LoginPage');
      }
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase dengan pesan yang lebih baik
      String errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = 'Email atau Password yang Anda masukkan salah.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email yang Anda masukkan tidak valid.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
      }
      _showAlertDialog('Login Gagal', errorMessage, isSuccess: false);
      log('Firebase Auth error: ${e.code}', name: 'LoginPage');
    } catch (e) {
      // Menangani error umum (misal: tidak ada koneksi internet)
      _showAlertDialog(
        'Login Gagal',
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        isSuccess: false,
      );
      log('Generic error: $e', name: 'LoginPage');
    } finally {
      // Pastikan loading dihentikan, baik berhasil maupun gagal
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- UI WIDGET (BUILD) DIPERTAHANKAN SEPENUHNYA DARI KODE LAMA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Ditambahkan untuk menghindari overflow di layar kecil
        child: ConstrainedBox(
          // Memastikan konten mengisi layar
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Bagian Atas: Logo dan Tagline
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Pro ',
                                  style: TextStyle(
                                    fontFamily:
                                        'Arial', // Pastikan font ini ada atau ganti
                                    fontSize: 35,
                                    color: Color(0xFF0000FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Assets',
                                  style: TextStyle(
                                    fontFamily:
                                        'Arial', // Pastikan font ini ada atau ganti
                                    fontSize: 35,
                                    color: Color(0xFF646464),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Manage, Track and Secure Your Assets at Your Fingertips.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily:
                                  'Jost', // Pastikan font ini ada di pubspec
                              fontSize: 15,
                              color: Color(0xFF0000FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bagian Bawah: Form Login
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Form Input Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Form Input Password
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E4AE3),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tombol Login
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E4AE3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          // Tampilkan loading indicator atau teks 'Login'
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
