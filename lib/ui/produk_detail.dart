import 'package:flutter/material.dart';
import 'package:buku/bloc/produk_bloc.dart';
import 'package:buku/model/produk.dart';
import 'package:buku/ui/produk_form.dart';

/// Halaman detail produk buku
class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  final Color _softOrange = const Color(0xFFFFB74D); // Tema orange lembut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _softOrange,
        title: const Text('Detail Buku'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kode Buku : ${widget.produk!.kodeBuku}",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Judul Buku : ${widget.produk!.namaBuku}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8),
                Text(
                  "Penulis : ${widget.produk!.penulis}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8),
                Text(
                  "Penerbit : ${widget.produk!.penerbit}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tahun Terbit : ${widget.produk!.tahunTerbit}",
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8),
                // Menambahkan deskripsi
                Text(
                  "Deskripsi : ${widget.produk!.deskripsi ?? '-'}",
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 24),
                _tombolHapusEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tombol Edit dan Delete
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Edit
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text("EDIT"),
          style: ElevatedButton.styleFrom(
            backgroundColor: _softOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk!),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        // Tombol Delete
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text("DELETE"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          onPressed: confirmHapus,
        ),
      ],
    );
  }

  /// Konfirmasi hapus produk
  void confirmHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Yakin ingin menghapus data buku ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Ya, Hapus",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              bool success =
              await ProdukBloc.deleteProduk(id: widget.produk!.id!);
              Navigator.pop(context); // tutup dialog

              if (success) {
                Navigator.pop(context); // kembali ke halaman list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Produk berhasil dihapus")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gagal menghapus produk")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
