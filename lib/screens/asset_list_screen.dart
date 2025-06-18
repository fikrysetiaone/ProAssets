// lib/screens/asset_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proassets/models/asset.dart'; // Sesuaikan path
import 'package:proassets/widgets/asset_card.dart'; // Sesuaikan path

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Aset")),
      body: StreamBuilder<QuerySnapshot>(
        // Ini adalah "pipa" yang terus mendengarkan koleksi 'assets'
        stream: FirebaseFirestore.instance.collection('assets').snapshots(),
        builder: (context, snapshot) {
          // Tampilkan loading indicator saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Tampilkan pesan jika tidak ada data atau terjadi error
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada aset."));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan."));
          }

          // Jika data ada, bangun daftar aset
          final assetDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: assetDocs.length,
            itemBuilder: (context, index) {
              final doc = assetDocs[index];
              final asset = Asset.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              return AssetCard(
                asset: asset,
                onTap: () {
                  // TODO: Navigasi ke halaman detail
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke halaman tambah aset
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}