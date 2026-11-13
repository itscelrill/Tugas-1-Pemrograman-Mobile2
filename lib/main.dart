// LATIHAN · Sesi 4: Latihan Kelas & Tantangan Riverpod 3.0
// Tugas 1: totalHargaProvider (Provider<int>) yang menghitung total Rp dari cartProvider menggunakan fold (Slide 20)
// Tugas 2: ref.listen() untuk SnackBar diskon saat keranjang mencapai 5 item (Slide 19)
// Fitur Reset: ref.invalidate(cartProvider) untuk mengembalikan keranjang ke kondisi awal (Slide 19)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu {
  const Menu(this.nama, this.harga);
  final String nama;
  final int harga;
}

const daftarMenu = [
  Menu('Es Kopi Susu', 12000),
  Menu('Nasi Goreng', 15000),
  Menu('Mie Ayam', 13000),
];

class CartNotifier extends Notifier<List<Menu>> {
  @override
  List<Menu> build() => [];

  void tambah(Menu menu) => state = [...state, menu];
  void kosongkan() => state = [];
}

final cartProvider = NotifierProvider<CartNotifier, List<Menu>>(
  CartNotifier.new,
);

// ============================================================================
// TANTANGAN #1: totalHargaProvider (Slide 20 - DartPad)
// Perintah: Provider membaca provider lain dengan ref.watch, lalu jumlahkan dengan fold.
// Target: Menghitung total harga keranjang.
// ============================================================================
// TODO 1: ubah provider ini agar menghitung total harga dari cartProvider.
final totalHargaProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.harga);
});

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: KantinPage(),
      ),
    ),
  );
}

class KantinPage extends ConsumerWidget {
  const KantinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 2 (Tantangan #1): Tampilkan total dari totalHargaProvider di judul AppBar
    final total = ref.watch(totalHargaProvider);

    // ========================================================================
    // TANTANGAN #2 (Slide 19): ref.listen() untuk SnackBar Diskon
    // Perintah: Menambahkan ref.listen() untuk SnackBar diskon saat keranjang mencapai 5 item.
    // ========================================================================
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Total: Rp $total'),
        actions: [
          // Fitur Ringkasan Slide 19: Reset mudah dengan ref.invalidate
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Keranjang (ref.invalidate)',
            onPressed: () {
              ref.invalidate(cartProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Keranjang berhasil dikosongkan'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final m in daftarMenu)
            ListTile(
              title: Text(m.nama),
              subtitle: Text('Rp ${m.harga}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => ref.read(cartProvider.notifier).tambah(m),
              ),
            ),
        ],
      ),
    );
  }
}
