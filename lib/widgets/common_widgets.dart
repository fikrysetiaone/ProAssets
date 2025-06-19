// lib/widgets/common_widgets.dart

import 'package:flutter/material.dart';
// DIUBAH: Path relatif untuk menjangkau folder screens
import '../screens/dashboard/dashboard.dart';
import '../screens/assets/daftar-assets.dart';
import '../screens/hand_over/hand-over.dart';
import '../screens/profile/profile.dart';

// --- WIDGET APPBAR KUSTOM ---
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (Tidak ada perubahan di dalam kode widget ini)
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4300FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 24,
                      height: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 2)),
                  Container(
                      width: 24,
                      height: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 2)),
                  Container(
                      width: 24,
                      height: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 2)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                    text: 'Pro',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- WIDGET DRAWER KUSTOM ---
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Tutup drawer
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // ... (Tidak ada perubahan di dalam kode widget ini)
    const TextStyle drawerMenuItemTextStyle = TextStyle(
        fontFamily: 'Arial',
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.normal);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: const Color(0xFF4300FF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'Pro', style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: 'Assets',
                            style: TextStyle(color: Color(0xFF646464))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    leading: const Icon(Icons.dashboard_rounded,
                        color: Colors.white),
                    title:
                        const Text('Dashboard', style: drawerMenuItemTextStyle),
                    onTap: () => _navigateTo(context, const DashboardScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.inventory_2_rounded,
                        color: Colors.white),
                    title: const Text('Assets', style: drawerMenuItemTextStyle),
                    onTap: () => _navigateTo(context, const AssetsScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz_rounded,
                        color: Colors.white),
                    title: const Text('Serah terima',
                        style: drawerMenuItemTextStyle),
                    onTap: () => _navigateTo(context, const HandOverScreen()),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: 3,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 15)),
                  ListTile(
                    leading:
                        const Icon(Icons.person_rounded, color: Colors.white),
                    title:
                        const Text('Profile', style: drawerMenuItemTextStyle),
                    onTap: () => _navigateTo(context, const ProfileScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
