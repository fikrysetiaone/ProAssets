// lib/screens/assets/daftar-assets.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// DIUBAH: Import widget kustom kita
import 'package:proassets/widgets/common_widgets.dart';

// Mengubah nama class agar sesuai dengan konvensi Dart (PascalCase)
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi koleksi dipindahkan ke atas agar lebih rapi
    final CollectionReference assetsCollection =
        FirebaseFirestore.instance.collection('assets');

    return Scaffold(
      // --- DIUBAH: Menggunakan AppBar dan Drawer kustom ---
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      // --------------------------------------------------

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Halaman
          const Padding(
            padding: EdgeInsets.fromLTRB(
                16, 24, 16, 8), // Sedikit penyesuaian padding
            child: Text(
              'Daftar Assets',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),

          // Search bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama aset...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xFF0E4AE3), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xFF0E4AE3), width: 2),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0E4AE3)),
              ),
            ),
          ),

          // Header kolom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: const Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Nama Asset',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('User',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 48) // Beri ruang untuk tombol edit
              ],
            ),
          ),

          // Daftar aset dari Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Query diubah untuk mengurutkan berdasarkan nama
              stream: assetsCollection.orderBy('nama').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Terjadi kesalahan memuat data.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Tidak ada aset ditemukan.'));
                }

                final allAssets = snapshot.data!.docs;

                // Logika filter dipindahkan ke sini
                final filteredAssets = allAssets.where((doc) {
                  // Mengambil data dengan aman
                  final assetData = doc.data() as Map<String, dynamic>? ?? {};
                  final nama =
                      (assetData['nama'] as String? ?? '').toLowerCase();
                  return nama.contains(_searchQuery);
                }).toList();

                if (filteredAssets.isEmpty) {
                  return const Center(
                      child: Text('Aset yang dicari tidak ditemukan.'));
                }

                return ListView.builder(
                  itemCount: filteredAssets.length,
                  itemBuilder: (context, index) {
                    final asset = filteredAssets[index];
                    final assetData =
                        asset.data() as Map<String, dynamic>? ?? {};

                    // Tampilan per baris aset
                    return InkWell(
                      onTap: () {
                        // TODO: Tambahkan aksi saat baris di-klik, misal ke halaman detail
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${assetData['nama'] ?? ''} diklik!')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3, child: Text(assetData['nama'] ?? '-')),
                            Expanded(
                                flex: 2,
                                child: Text(assetData['status'] ?? '-')),
                            Expanded(
                                flex: 2,
                                child: Text(assetData['user'] ?? '-',
                                    overflow: TextOverflow.ellipsis)),
                            SizedBox(
                              width: 48,
                              child: IconButton(
                                icon: const Icon(Icons.edit_note_rounded,
                                    color: Colors.blueGrey),
                                tooltip: 'Edit aset',
                                onPressed: () {
                                  // TODO: Tambahkan navigasi ke halaman edit aset
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Edit ${assetData['nama'] ?? ''} diklik!')),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // --- BARU: Menambahkan Floating Action Button untuk menambah aset ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Tambahkan navigasi ke halaman tambah aset baru
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tombol Tambah Aset diklik!')),
          );
        },
        backgroundColor: const Color(0xFF4300FF),
        child: const Icon(Icons.add),
      ),
    );
  }
}
