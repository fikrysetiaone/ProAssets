// lib/models/asset.dart
class Asset {
  final String id; // ID dari dokumen Firestore
  final String nama;
  final String kodeAset;
  // ... field lainnya

  const Asset({required this.id, required this.nama, required this.kodeAset, ...});

  // Mengubah objek Asset menjadi Map untuk dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'kodeAset': kodeAset,
      // ... field lainnya
    };
  }

  // Membuat objek Asset dari Map yang diterima dari Firestore
  factory Asset.fromMap(Map<String, dynamic> map, String documentId) {
    return Asset(
      id: documentId,
      nama: map['nama'] ?? '',
      kodeAset: map['kodeAset'] ?? '',
      // ... field lainnya
    );
  }
}