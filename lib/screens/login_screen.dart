// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import halaman dashboard sebagai tujuan navigasi
import 'package:proassets/screens/dashboard/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlertDialog(
    String title,
    String message, {
    bool isSuccess = false,
  }) {
    Color dialogColor = isSuccess ? Colors.green : Colors.red;
    IconData dialogIcon = isSuccess ? Icons.check : Icons.close;
    String statusText = isSuccess ? 'SUCCESS!' : 'ERROR!';

    if (!mounted) return;
    final BuildContext currentContext = context;

    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration:
                    BoxDecoration(color: dialogColor, shape: BoxShape.circle),
                child: Icon(dialogIcon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(statusText,
                  style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 10),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.black54)),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: dialogColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (isSuccess) {
                    Navigator.pushAndRemoveUntil(
                      currentContext,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                      (Route<dynamic> route) => false,
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

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlertDialog(
          'Login Gagal', 'Email atau Password tidak boleh kosong.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        final user = userCredential.user!;
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userName =
            doc.exists ? (doc.data()?['name'] ?? user.email) : user.email;
        _showAlertDialog('Login Berhasil', 'Selamat Datang, $userName!',
            isSuccess: true);
      } else {
        setState(() => _isLoading = false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Email atau Password yang Anda masukkan salah.';
      if (e.code != 'invalid-credential' &&
          e.code != 'wrong-password' &&
          e.code != 'user-not-found') {
        errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
      _showAlertDialog('Login Gagal', errorMessage);
      setState(() => _isLoading = false);
    } catch (e) {
      _showAlertDialog('Login Gagal',
          'Tidak dapat terhubung. Periksa koneksi internet Anda.');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: 'Pro ',
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 35,
                                  color: Color(0xFF0000FF),
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Assets',
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 35,
                                  color: Color(0xFF646464),
                                  fontWeight: FontWeight.bold)),
                        ])),
                        const SizedBox(height: 8),
                        const Text(
                            'Manage, Track and Secure Your Assets at Your Fingertips.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 15,
                                color: Color(0xFF0000FF))),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      color: Color(0xFF0E4AE3), width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF0E4AE3), width: 2.0))),
                        ),
                        const SizedBox(height: 16),
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
                                      color: Color(0xFF0E4AE3), width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF0E4AE3), width: 2.0))),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0E4AE3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3))
                              : const Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
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
