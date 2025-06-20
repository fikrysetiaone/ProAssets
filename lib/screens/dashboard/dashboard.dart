import 'package:flutter/material.dart';
// DIUBAH: Path import baru ke folder widgets
import 'package:proassets/widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Selamat Datang di Dashboard!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
