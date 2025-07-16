class KainModel {
  final String id;
  final String nama;
  final String warna;
  final int harga;

  KainModel({
    required this.id,
    required this.nama,
    required this.warna,
    required this.harga,
  });

  factory KainModel.fromFirestore(Map<String, dynamic> data, String id) {
    return KainModel(
      id: id,
      nama: data['nama'] ?? '-',
      warna: data['warna'] ?? '-',
      harga: data['harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'warna': warna,
      'harga': harga,
    };
  }
}
 