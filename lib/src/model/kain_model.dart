class KainModel {
  final String id;
  final String nama;
  final String warna;
  final int harga;
  final String deskripsi;
  final double kebutuhanMeter; // Kebutuhan kain per item (dalam meter)
  final int biayaJahitDasar; // Biaya jahit dasar per item

  // Tambahan field untuk kebutuhan kain per kategori umur
  final Map<String, double> kebutuhanKainPerKategori;
  final Map<String, int> biayaJahitPerKategori;

  KainModel({
    required this.id,
    required this.nama,
    required this.warna,
    required this.harga,
    required this.deskripsi,
    required this.kebutuhanMeter,
    required this.biayaJahitDasar,
    Map<String, double>? kebutuhanKainPerKategori,
    Map<String, int>? biayaJahitPerKategori,
  }) : kebutuhanKainPerKategori =
           kebutuhanKainPerKategori ??
           {
             'bayi': 0.4,
             'balita': 0.6,
             'anak': 0.8,
             'remaja': 1.0,
             'dewasa': 1.2,
             'lansia': 1.3,
           },
       biayaJahitPerKategori =
           biayaJahitPerKategori ??
           {
             'bayi': 25000,
             'balita': 35000,
             'anak': 45000,
             'remaja': 55000,
             'dewasa': 60000,
             'lansia': 70000,
           };

  factory KainModel.fromFirestore(Map<String, dynamic> data, String id) {
    // Parse kebutuhan kain per kategori
    Map<String, double> kebutuhanKainPerKategori = {};
    if (data['kebutuhanKainPerKategori'] != null) {
      Map<String, dynamic> rawData = data['kebutuhanKainPerKategori'];
      rawData.forEach((key, value) {
        kebutuhanKainPerKategori[key] = (value ?? 0.0).toDouble();
      });
    }

    // Parse biaya jahit per kategori
    Map<String, int> biayaJahitPerKategori = {};
    if (data['biayaJahitPerKategori'] != null) {
      Map<String, dynamic> rawData = data['biayaJahitPerKategori'];
      rawData.forEach((key, value) {
        biayaJahitPerKategori[key] = value ?? 0;
      });
    }

    return KainModel(
      id: id,
      nama: data['nama'] ?? '-',
      warna: data['warna'] ?? '-',
      harga: data['harga'] ?? 0,
      deskripsi: data['deskripsi'] ?? '-',
      kebutuhanMeter: (data['kebutuhanMeter'] ?? 1.0).toDouble(),
      biayaJahitDasar: data['biayaJahitDasar'] ?? 0,
      kebutuhanKainPerKategori: kebutuhanKainPerKategori,
      biayaJahitPerKategori: biayaJahitPerKategori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'warna': warna,
      'harga': harga,
      'deskripsi': deskripsi,
      'kebutuhanMeter': kebutuhanMeter,
      'biayaJahitDasar': biayaJahitDasar,
      'kebutuhanKainPerKategori': kebutuhanKainPerKategori,
      'biayaJahitPerKategori': biayaJahitPerKategori,
    };
  }

  // Method untuk menghitung estimasi harga total
  int hitungEstimasiHarga({
    required String jenisPakaian,
    required String ukuran,
    required bool isExpress,
    required bool isCustomUkuran,
    String kategoriUmur = 'dewasa',
    String lokasi = 'kota_kecil', // Tambahan parameter lokasi
  }) {
    // Biaya kain - gunakan kebutuhan kain per kategori
    double kebutuhanKain =
        kebutuhanKainPerKategori[kategoriUmur.toLowerCase()] ?? kebutuhanMeter;

    // Faktor lokasi
    double faktorLokasi = 1.0;
    switch (lokasi.toLowerCase()) {
      case 'desa':
        faktorLokasi = 0.8; // 20% lebih murah di desa
        break;
      case 'kota_kecil':
        faktorLokasi = 1.0; // Harga standar
        break;
      case 'kota_besar':
        faktorLokasi = 1.3; // 30% lebih mahal di kota besar
        break;
      default:
        faktorLokasi = 1.0;
    }

    // Tambahan untuk ukuran custom
    if (isCustomUkuran) {
      kebutuhanKain *= 1.2; // 20% tambahan untuk custom ukuran
    }

    // Faktor kebutuhan kain berdasarkan ukuran
    double faktorUkuran = 1.0;
    switch (ukuran.toLowerCase()) {
      case 'xs':
        faktorUkuran = 0.8; // 20% lebih sedikit untuk XS
        break;
      case 's':
        faktorUkuran = 0.9; // 10% lebih sedikit untuk S
        break;
      case 'm':
        faktorUkuran = 1.0; // Ukuran standar
        break;
      case 'l':
        faktorUkuran = 1.1; // 10% lebih banyak untuk L
        break;
      case 'xl':
        faktorUkuran = 1.2; // 20% lebih banyak untuk XL
        break;
      case 'xxl':
        faktorUkuran = 1.3; // 30% lebih banyak untuk XXL
        break;
      case 'xxxl':
        faktorUkuran = 1.4; // 40% lebih banyak untuk XXXL
        break;
      default:
        if (isCustomUkuran) {
          faktorUkuran = 1.5; // 50% lebih banyak untuk custom ukuran
        }
    }

    // Terapkan faktor ukuran pada kebutuhan kain
    kebutuhanKain *= faktorUkuran;

    // Tambahan waste/limbah
    kebutuhanKain *= 1.15; // 15% waste

    int biayaKain = (kebutuhanKain * harga).round();

    // Biaya jahit - gunakan biaya jahit per kategori
    int biayaJahit =
        biayaJahitPerKategori[kategoriUmur.toLowerCase()] ?? biayaJahitDasar;

    // Markup berdasarkan jenis pakaian
    switch (jenisPakaian.toLowerCase()) {
      case 'celana':
        biayaJahit = (biayaJahit * 1.0).round(); // Harga dasar
        break;
      case 'kaos':
      case 'oblong':
        biayaJahit = (biayaJahit * 0.8).round(); // Lebih murah
        break;
      case 'baju':
      case 'kemeja':
        biayaJahit = (biayaJahit * 1.2).round(); // Lebih mahal
        break;
      case 'jas':
      case 'blazer':
        biayaJahit = (biayaJahit * 2.0).round(); // Paling mahal
        break;
      default:
        biayaJahit = biayaJahitDasar;
    }

    // Markup untuk ukuran
    switch (ukuran.toLowerCase()) {
      case 'xs':
      case 's':
        biayaJahit = (biayaJahit * 0.9).round();
        break;
      case 'm':
        biayaJahit = biayaJahit; // Harga dasar
        break;
      case 'l':
        biayaJahit = (biayaJahit * 1.1).round();
        break;
      case 'xl':
        biayaJahit = (biayaJahit * 1.2).round();
        break;
      case 'xxl':
      case 'xxxl':
        biayaJahit = (biayaJahit * 1.3).round();
        break;
      default:
        if (isCustomUkuran) {
          biayaJahit = (biayaJahit * 1.5).round(); // Custom ukuran
        }
    }

    // Biaya express
    if (isExpress) {
      biayaJahit = (biayaJahit * 1.5).round(); // 50% tambahan untuk express
    }

    // Terapkan faktor lokasi
    int totalBiaya = biayaKain + biayaJahit;
    totalBiaya = (totalBiaya * faktorLokasi).round();

    return totalBiaya;
  }
}
