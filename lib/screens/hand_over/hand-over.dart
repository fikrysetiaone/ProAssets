import 'package:flutter/material.dart';
// DIUBAH: Path import baru ke folder widgets
import 'package:proassets/widgets/common_widgets.dart';

class HandOverScreen extends StatelessWidget {
  const HandOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Halaman Serah Terima', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
