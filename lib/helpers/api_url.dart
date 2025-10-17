class ApiUrl {
  static const String baseUrl = 'http://localhost/BukuKu/public/';

  static const String registrasi = baseUrl + 'registrasi';
  static const String login = baseUrl + 'login';
  static const String listProduk = baseUrl + 'produk';
  static const String createProduk = baseUrl + 'produk';

  static String updateProduk(int id) => baseUrl + 'produk/' + id.toString();

  static String showProduk(int id) => baseUrl + 'produk/' + id.toString();

  static String deleteProduk(int id) => baseUrl + 'produk/' + id.toString();
}
