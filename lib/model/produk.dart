
class Produk {
  int? id;
  String? kodeBuku;
  String? namaBuku;
  String? penulis;
  String? penerbit;
  int? tahunTerbit;
  String? deskripsi;


  Produk({
    this.id,
    this.kodeBuku,
    this.namaBuku,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.deskripsi,
  });

  /// Factory constructor untuk membuat Produk dari JSON
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      // id bisa berupa int atau String, diubah menjadi int
      id: obj['id'] is int ? obj['id'] : int.tryParse(obj['id'].toString()),

      // Field String null safe
      kodeBuku: obj['kode_buku'] as String?,
      namaBuku: obj['nama_buku'] as String?,
      penulis: obj['penulis'] as String?,
      penerbit: obj['penerbit'] as String?,

      // tahunTerbit bisa null atau String, diubah menjadi int
      tahunTerbit: obj['tahun_terbit'] == null
          ? null
          : int.tryParse(obj['tahun_terbit'].toString()),

      // Deskripsi buku, bisa null
      deskripsi: obj['deskripsi'] as String?,
    );
  }

  /// Method untuk convert Produk menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_buku': kodeBuku,
      'nama_buku': namaBuku,
      'penulis': penulis,
      'penerbit': penerbit,
      'tahun_terbit': tahunTerbit,
      'deskripsi': deskripsi,
    };
  }
}
