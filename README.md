# Latihan & Tantangan Riverpod 3.0: Aplikasi Kantin Kampus
> **Tugas 1 & 2 Pemrograman Mobile 2**  
> Implementasi State Management Modern dengan Flutter & Riverpod 3.0

---

## 📌 Deskripsi Proyek

Aplikasi ini merupakan implementasi studi kasus **Kantin Kampus** berbasis **Flutter** dan **Riverpod 3.0** (`flutter_riverpod: ^3.5.0`). Proyek ini menyelesaikan tantangan pemrograman pada sesi manajemen state deklaratif untuk mengatasi masalah *prop drilling* serta memisahkan logika bisnis dari UI.

Proyek ini mencakup penyelesaian lengkap dari:
1. **Tantangan #1 (Slide 20 / DartPad)**: Perhitungan total harga keranjang secara reaktif.
2. **Tantangan #2 (Slide 19)**: Notifikasi diskon otomatis menggunakan `ref.listen()` saat keranjang mencapai 5 item.
3. **Fitur Reset (Slide 19)**: Mengembalikan state keranjang ke kondisi awal menggunakan `ref.invalidate()`.

---

## 🚀 Fitur & Implementasi Tantangan

### 1. Tantangan #1: `totalHargaProvider` (Slide 20)
- **Target**: Menampilkan akumulasi total harga belanjaan pada judul `AppBar`.
- **Implementasi**:
  - Dibuat `totalHargaProvider` bertipe `Provider<int>`.
  - Menggunakan `ref.watch(cartProvider)` untuk berlangganan perubahan isi keranjang.
  - Menghitung total nominal rupiah menggunakan fungsi iterasi koleksi `.fold()`:
    ```dart
    final totalHargaProvider = Provider<int>((ref) {
      final cart = ref.watch(cartProvider);
      return cart.fold(0, (total, item) => total + item.harga);
    });
    ```
  - Pada `KantinPage` (`ConsumerWidget`), nilai dibaca secara reaktif:
    ```dart
    final total = ref.watch(totalHargaProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Total: Rp $total')),
      ...
    );
    ```

### 2. Tantangan #2: SnackBar Diskon dengan `ref.listen()` (Slide 19)
- **Target**: Memberikan notifikasi banner/SnackBar diskon ketika pengguna menambahkan item ke-5 ke dalam keranjang belanja.
- **Implementasi**:
  - Menggunakan senjata ketiga dari `WidgetRef`, yaitu `ref.listen()`, di dalam metode `build()` tanpa menyebabkan *unnecessary rebuild* pada widget:
    ```dart
    ref.listen<List<Menu>>(cartProvider, (previous, next) {
      if (next.length == 5 && (previous?.length ?? 0) < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Selamat! Anda mendapatkan diskon karena keranjang mencapai 5 item!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
    ```

### 3. Fitur Reset Keranjang: `ref.invalidate()` (Slide 19)
- **Target**: Mengosongkan keranjang kembali ke kondisi awal dengan mudah.
- **Implementasi**:
  - Tombol aksi refresh pada `AppBar` memicu `ref.invalidate(cartProvider)`, yang secara otomatis membuang state lama dan menginisialisasi ulang provider:
    ```dart
    IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Reset Keranjang (ref.invalidate)',
      onPressed: () {
        ref.invalidate(cartProvider);
      },
    )
    ```

---

## 💡 Konsep Riverpod 3.0 yang Dipelajari

1. **`ProviderScope`**:
   Bungkus root aplikasi di `runApp()` yang bertindak sebagai gudang state global di luar pohon widget, menghilangkan `ProviderNotFoundException`.
2. **`Notifier<T>` & `NotifierProvider`**:
   Standar modern Riverpod 3.0 untuk state mutable sinkron yang menggantikan `StateNotifier` dan `StateProvider`. Bersifat *immutable* (`state = [...state, item]`).
3. **Tiga Senjata `WidgetRef`**:
   - **`ref.watch()`**: Dipakai di dalam `build()` untuk berlangganan state dan me-rebuild UI secara otomatis saat nilai berubah.
   - **`ref.read()`**: Dipakai di dalam callback interaksi (seperti `onPressed`) untuk memanggil fungsi notifier sekali jalan tanpa me-rebuild widget.
   - **`ref.listen()`**: Dipakai di dalam `build()` untuk mengeksekusi efek samping (*side-effects*) seperti menampilkan SnackBar, dialog, atau navigasi tanpa rebuild.
4. **`ref.invalidate()`**:
   Mekanisme bawaan untuk me-refresh/me-reset state provider kembali ke nilai default `build()`.

---

## 📂 Struktur Proyek

```text
├── android/                   # Konfigurasi native Android
├── ios/                       # Konfigurasi native iOS
├── web/                       # Konfigurasi Flutter Web
├── windows/                   # Konfigurasi native Windows
├── lib/
│   └── main.dart              # Kode utama aplikasi (Riverpod Providers & UI)
├── test/
│   └── widget_test.dart       # Widget & smoke tests
├── pubspec.yaml               # Dependensi proyek (flutter_riverpod: ^3.5.0)
└── README.md                  # Dokumentasi proyek
```

---

## 🛠️ Cara Menjalankan Aplikasi

### 1. Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.10 atau lebih baru)
- Dart SDK (versi 3.0 atau lebih baru)

### 2. Langkah Menjalankan
1. Clone repositori ini:
   ```bash
   git clone https://github.com/itscelrill/Tugas-1-Pemrograman-Mobile2.git
   cd Tugas-1-Pemrograman-Mobile2
   ```
2. Unduh paket dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:
   ```bash
   flutter run
   ```
   *(Pilih target Chrome, Windows Desktop, atau Emulator Android/iOS sesuai preferensi)*

---

## 👤 Penyusun & Pengembang

- **Materi & Studi Kasus**: Septian Cahyadi & M. Saad Nurul Ishlah (Universitas Pakuan - *Edisi Riverpod 3.0*)
- **Pengembang Mahasiswa**: Calvin Emerson Leonardi
