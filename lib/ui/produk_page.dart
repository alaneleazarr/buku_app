import 'package:flutter/material.dart';
import 'package:buku/bloc/logout_bloc.dart';
import 'package:buku/bloc/produk_bloc.dart';
import 'package:buku/model/produk.dart';
import 'package:buku/ui/login_page.dart';
import 'package:buku/ui/produk_detail.dart';
import 'package:buku/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> _produks = [];
  List<Produk> _filteredProduks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final Color _softOrange = const Color(0xFFFFB74D);

  @override
  void initState() {
    super.initState();
    _loadProduks();
    _searchController.addListener(_filterProduks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProduks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var produks = await ProdukBloc.getProduks();
      setState(() {
        _produks = produks;
        _filteredProduks = produks;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat data produk")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProduks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProduks = _produks
          .where((p) => (p.namaBuku ?? "").toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToDetail(Produk produk) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
    );
    _loadProduks(); // refresh otomatis setelah kembali dari detail
  }

  void _navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdukForm()),
    );
    _loadProduks(); // refresh otomatis setelah tambah produk
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _softOrange,
        title: const Text('List Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToForm, // tombol tambah produk
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _softOrange),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ======= Search bar =======
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // ======= Produk list =======
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProduks.isEmpty
                ? const Center(child: Text("Tidak Ada Produk"))
                : ListView.builder(
              itemCount: _filteredProduks.length,
              itemBuilder: (context, i) {
                var produk = _filteredProduks[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.orange.shade50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: const Icon(
                        Icons.book, // ikon buku di kiri
                        color: Colors.orange,
                        size: 36,
                      ),
                      title: Text(
                        produk.namaBuku ?? "-",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _navigateToDetail(produk),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
