# Sistem Estimasi Harga Jasa Jahit Custom

## 📋 Daftar Isi
1. [Overview Sistem](#overview-sistem)
2. [Komponen Utama](#komponen-utama)
3. [Faktor-faktor Estimasi Harga](#faktor-faktor-estimasi-harga)
4. [Rumus Perhitungan](#rumus-perhitungan)
5. [Contoh Perhitungan](#contoh-perhitungan)
6. [Implementasi dalam Kode](#implementasi-dalam-kode)
7. [Cara Penggunaan](#cara-penggunaan)
8. [Parameter dan Konstanta](#parameter-dan-konstanta)

---

## 🎯 Overview Sistem

Program jasa jahit ini memiliki sistem estimasi harga yang komprehensif untuk **jasa jahit custom** (bukan pesan model yang sudah jadi). Sistem ini menggunakan algoritma perhitungan yang mempertimbangkan berbagai faktor untuk memberikan estimasi harga yang akurat.

### Fitur Utama
- ✅ Kalkulator estimasi harga lengkap
- ✅ Estimasi otomatis berdasarkan ukuran badan
- ✅ Perhitungan real-time
- ✅ Faktor lokasi dan layanan tambahan
- ✅ Integrasi dengan sistem pesanan

---

## 🏗️ Komponen Utama

### 1. **KalkulatorHargaScreen**
- Interface utama untuk input parameter dan perhitungan
- Memiliki semua opsi untuk estimasi yang akurat
- Tampilan hasil estimasi yang detail

### 2. **KainModel**
- Model data kain dengan informasi harga per meter
- Method `hitungEstimasiHarga()` untuk perhitungan
- Konstanta kebutuhan kain dan biaya jahit per kategori

### 3. **Estimasi Otomatis**
- **UkuranBajuCustomerScreen**: Estimasi baju berdasarkan ukuran badan
- **UkuranCelanaCustomerScreen**: Estimasi celana berdasarkan ukuran badan

---

## 🔢 Faktor-faktor Estimasi Harga

### A. **Kategori Umur**
| Kategori | Kebutuhan Kain | Biaya Jahit |
|----------|----------------|-------------|
| Bayi     | 0.4m          | Rp 25.000   |
| Balita   | 0.6m          | Rp 35.000   |
| Anak     | 0.8m          | Rp 45.000   |
| Remaja   | 1.0m          | Rp 55.000   |
| **Dewasa** | **1.2m**     | **Rp 60.000** |
| Lansia   | 1.3m          | Rp 70.000   |

### B. **Jenis Pakaian**
| Jenis Pakaian | Faktor Markup | Keterangan |
|---------------|---------------|------------|
| Celana        | ×1.0          | Harga dasar |
| Kaos/Oblong   | ×0.8          | Lebih murah |
| Baju/Kemeja   | ×1.2          | Lebih mahal |
| **Jas/Blazer** | **×2.0**     | **Paling mahal** |

### C. **Ukuran Pakaian**
| Ukuran | Faktor Kain | Faktor Jahit | Keterangan |
|--------|-------------|---------------|------------|
| XS     | ×0.8        | ×0.9          | 20% lebih sedikit |
| S      | ×0.9        | ×0.9          | 10% lebih sedikit |
| M      | ×1.0        | ×1.0          | Ukuran standar |
| **L**  | **×1.1**    | **×1.1**      | **10% lebih banyak** |
| XL     | ×1.2        | ×1.2          | 20% lebih banyak |
| XXL    | ×1.3        | ×1.3          | 30% lebih banyak |
| XXXL   | ×1.4        | ×1.3          | 40% lebih banyak |
| Custom | ×1.5        | ×1.5          | 50% lebih banyak |

### D. **Lokasi**
| Lokasi     | Faktor | Keterangan |
|------------|--------|------------|
| Desa       | ×0.8   | 20% lebih murah |
| Kota Kecil | ×1.0   | Harga standar |
| **Kota Besar** | **×1.3** | **30% lebih mahal** |

### E. **Layanan Tambahan**
| Layanan | Faktor | Keterangan |
|---------|--------|------------|
| Express (1-2 hari) | ×1.5 | 50% tambahan |
| Ukuran Custom | ×1.2 (kain) + ×1.5 (jahit) | Tambahan untuk ukuran khusus |

---

## 🧮 Rumus Perhitungan

### Formula Utama
```
Total Harga = (Biaya Kain + Biaya Jahit) × Faktor Lokasi
```

### Detail Perhitungan

#### 1. **Biaya Kain**
```
Kebutuhan Kain = Kebutuhan Dasar × Faktor Ukuran × Faktor Custom × Waste
Biaya Kain = Kebutuhan Kain × Harga per Meter

Dimana:
- Waste = 1.15 (15% tambahan untuk limbah)
- Faktor Custom = 1.2 jika ukuran custom
```

#### 2. **Biaya Jahit**
```
Biaya Jahit = Biaya Dasar × Markup Jenis × Markup Ukuran × Faktor Express

Dimana:
- Markup Jenis = berdasarkan jenis pakaian
- Markup Ukuran = berdasarkan ukuran pakaian
- Faktor Express = 1.5 jika express
```

---

## 📊 Contoh Perhitungan

### **Contoh: Jas untuk Dewasa Ukuran L di Kota Besar dengan Express**

#### **Langkah 1: Biaya Kain**
```
Kebutuhan Dasar (Dewasa) = 1.2m
Faktor Ukuran L = ×1.1
Faktor Custom = ×1.0 (bukan custom)
Waste = ×1.15

Kebutuhan Total = 1.2 × 1.1 × 1.0 × 1.15 = 1.518m
Biaya Kain = 1.518m × Rp 50.000/m = Rp 75.900
```

#### **Langkah 2: Biaya Jahit**
```
Biaya Dasar (Dewasa) = Rp 60.000
Markup Jas = ×2.0
Markup Ukuran L = ×1.1
Faktor Express = ×1.5

Biaya Jahit = Rp 60.000 × 2.0 × 1.1 × 1.5 = Rp 198.000
```

<!-- #### **Langkah 3: Total dengan Faktor Lokasi**
```
Total Sebelum Lokasi = Rp 75.900 + Rp 198.000 = Rp 273.900
Faktor Kota Besar = ×1.3

Total Akhir = Rp 273.900 × 1.3 = **Rp 356.070** -->
```

---

## 💻 Implementasi dalam Kode

### **Method hitungEstimasiHarga()**

```dart
int hitungEstimasiHarga({
  required String jenisPakaian,
  required String ukuran,
  required bool isExpress,
  required bool isCustomUkuran,
  String kategoriUmur = 'dewasa',
  String lokasi = 'kota_kecil',
}) {
  // 1. Hitung kebutuhan kain
  double kebutuhanKain = kebutuhanKainPerKategori[kategoriUmur] ?? kebutuhanMeter;
  
  // 2. Terapkan faktor ukuran dan custom
  if (isCustomUkuran) kebutuhanKain *= 1.2;
  kebutuhanKain *= faktorUkuran;
  kebutuhanKain *= 1.15; // Waste
  
  // 3. Hitung biaya kain
  int biayaKain = (kebutuhanKain * harga).round();
  
  // 4. Hitung biaya jahit dengan markup
  int biayaJahit = biayaJahitPerKategori[kategoriUmur] ?? biayaJahitDasar;
  biayaJahit = _hitungMarkupJahit(biayaJahit, jenisPakaian, ukuran, isExpress);
  
  // 5. Terapkan faktor lokasi
  int totalBiaya = biayaKain + biayaJahit;
  totalBiaya = (totalBiaya * _getFaktorLokasi(lokasi)).round();
  
  return totalBiaya;
}
```

---

## 🚀 Cara Penggunaan

### **Metode 1: Kalkulator Lengkap**
1. Buka `KalkulatorHargaScreen`
2. Pilih kain dari daftar yang tersedia
3. Input semua parameter:
   - Jenis pakaian
   - Kategori umur
   - Ukuran
   - Lokasi
   - Opsi express dan custom
4. Lihat estimasi harga real-time
5. Lanjut ke pesanan

### **Metode 2: Estimasi Otomatis**
1. Pilih kategori: Baju atau Celana
2. Input ukuran badan:
   - **Baju**: Lingkar dada, lebar bahu, panjang baju
   - **Celana**: Lingkar pinggang, panjang celana
3. Pilih kain
4. Sistem otomatis menghitung estimasi
5. Lanjut ke konfirmasi desain

---

## 📝 Parameter dan Konstanta

### **Konstanta Kebutuhan Kain**
```dart
Map<String, double> kebutuhanKainPerKategori = {
  'bayi': 0.4,      // Bayi: 0.4 meter
  'balita': 0.6,    // Balita: 0.6 meter
  'anak': 0.8,      // Anak: 0.8 meter
  'remaja': 1.0,    // Remaja: 1.0 meter
  'dewasa': 1.2,    // Dewasa: 1.2 meter
  'lansia': 1.3,    // Lansia: 1.3 meter
};
```

### **Konstanta Biaya Jahit**
```dart
Map<String, int> biayaJahitPerKategori = {
  'bayi': 25000,     // Bayi: Rp 25.000
  'balita': 35000,   // Balita: Rp 35.000
  'anak': 45000,     // Anak: Rp 45.000
  'remaja': 55000,   // Remaja: Rp 55.000
  'dewasa': 60000,   // Dewasa: Rp 60.000
  'lansia': 70000,   // Lansia: Rp 70.000
};
```

### **Faktor Markup Jenis Pakaian**
```dart
Map<String, double> markupJenisPakaian = {
  'celana': 1.0,     // Harga dasar
  'kaos': 0.8,       // 20% lebih murah
  'oblong': 0.8,     // 20% lebih murah
  'baju': 1.2,       // 20% lebih mahal
  'kemeja': 1.2,     // 20% lebih mahal
  'jas': 2.0,        // 100% lebih mahal
  'blazer': 2.0,     // 100% lebih mahal
};
```

### **Faktor Markup Ukuran**
```dart
Map<String, double> markupUkuran = {
  'xs': 0.9,         // 10% lebih murah
  's': 0.9,          // 10% lebih murah
  'm': 1.0,          // Harga standar
  'l': 1.1,          // 10% lebih mahal
  'xl': 1.2,         // 20% lebih mahal
  'xxl': 1.3,        // 30% lebih mahal
  'xxxl': 1.3,       // 30% lebih mahal
  'custom': 1.5,     // 50% lebih mahal
};
```

### **Faktor Lokasi**
```dart
Map<String, double> faktorLokasi = {
  'desa': 0.8,       // 20% lebih murah
  'kota_kecil': 1.0, // Harga standar
  'kota_besar': 1.3, // 30% lebih mahal
};
```

---

## 🔧 Integrasi dengan Sistem

### **Flow Estimasi Harga**
1. **Input Parameter** → Kalkulator/Estimasi Otomatis
2. **Perhitungan** → Method `hitungEstimasiHarga()`
3. **Hasil Estimasi** → Tampilan di UI
4. **Konfirmasi** → Simpan ke Order Model
5. **Pembayaran** → Gunakan estimasi harga

### **Field Order Model**
```dart
class Order {
  final int? estimatedPrice;    // Harga estimasi
  final String? estimatedSize;  // Ukuran estimasi
  final bool? isCustomSize;     // Apakah ukuran custom
  final String? selectedKain;   // Kain yang dipilih
  // ... field lainnya
}
```

---

## 📋 Catatan Penting

### **Status Implementasi**
- ✅ **KalkulatorHargaScreen**: Sudah dibuat, belum terintegrasi
- ✅ **Estimasi Otomatis**: Sudah berfungsi di halaman ukuran
- ✅ **Model dan Perhitungan**: Sudah lengkap
- ⚠️ **Integrasi UI**: Perlu ditambahkan tombol kalkulator

### **Rekomendasi Pengembangan**
1. **Tambahkan tombol "Kalkulator Harga"** di halaman utama
2. **Integrasikan KalkulatorHargaScreen** ke navigasi
3. **Tambahkan validasi input** untuk parameter
4. **Simpan riwayat estimasi** untuk analisis

---

## 📚 Referensi Kode

### **File Utama**
- `lib/src/customer/kalkulator_harga_screen.dart` - Kalkulator lengkap
- `lib/src/model/kain_model.dart` - Model dan perhitungan
- `lib/src/customer/ukuran_baju_customer_screen.dart` - Estimasi baju
- `lib/src/customer/ukuran_celana_customer_screen.dart` - Estimasi celana

### **Method Utama**
- `KainModel.hitungEstimasiHarga()` - Perhitungan estimasi
- `_hitungEstimasiHarga()` - Estimasi otomatis di UI

---

*Dokumentasi ini dibuat berdasarkan analisis kode aplikasi jasa jahit Flutter*
