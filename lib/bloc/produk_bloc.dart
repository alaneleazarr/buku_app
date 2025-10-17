import 'dart:convert';
import 'package:buku/helpers/api.dart';
import 'package:buku/helpers/api_url.dart';
import 'package:buku/model/produk.dart';

/// Bloc untuk mengelola data Produk
class ProdukBloc {
  // =========================
  // GET list produk
  // =========================

  /// Mengambil semua produk dari API
  ///
  /// Mengembalikan list [Produk] jika sukses
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);

    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];

    // Mapping dari JSON ke list Produk
    List<Produk> produks = listProduk.map((item) => Produk.fromJson(item)).toList();
    return produks;
  }

  // =========================
  // CREATE produk
  // =========================

  /// Menambahkan produk baru ke database melalui API
  ///
  /// [produk] = objek Produk yang akan ditambahkan
  /// Mengembalikan `true` jika sukses, `false` jika gagal
  static Future<bool> addProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_buku": produk.kodeBuku,
      "nama_buku": produk.namaBuku,
      "penulis": produk.penulis,
      "penerbit": produk.penerbit,
      "tahun_terbit": produk.tahunTerbit.toString(),
      "deskripsi": produk.deskripsi // Tambahkan deskripsi saat create
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] ?? false;
  }

  // =========================
  // UPDATE produk
  // =========================

  /// Mengubah data produk yang sudah ada
  ///
  /// [produk] = objek Produk yang akan diupdate
  /// Mengembalikan `true` jika sukses, `false` jika gagal
  static Future<bool> updateProduk({required Produk produk}) async {
    if (produk.id == null) return false;

    String apiUrl = ApiUrl.updateProduk(produk.id!); // http://host/produk/{id}

    var body = {
      "kode_buku": produk.kodeBuku,
      "nama_buku": produk.namaBuku,
      "penulis": produk.penulis,
      "penerbit": produk.penerbit,
      "tahun_terbit": produk.tahunTerbit,
      "deskripsi": produk.deskripsi // Deskripsi bisa diupdate juga
    };

    try {
      var response = await Api().put(
        apiUrl,
        json.encode(body),
        headers: {"Content-Type": "application/json"},
      );

      var jsonObj = json.decode(response.body);

      print("Update response: $jsonObj"); // debug

      return jsonObj['status'] ?? false;
    } catch (e) {
      print("Update failed: $e");
      return false;
    }
  }

  // =========================
  // DELETE produk
  // =========================

  /// Menghapus produk berdasarkan [id] melalui API
  ///
  /// Mengembalikan `true` jika berhasil dihapus, `false` jika gagal
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);
    var response = await Api().delete(apiUrl);

    var jsonObj = json.decode(response.body);

    // Cek tipe data dari backend
    if (jsonObj['data'] is bool) {
      return jsonObj['data'];
    } else if (jsonObj['data'] is int) {
      return jsonObj['data'] > 0;
    }

    return false; // fallback
  }
}
