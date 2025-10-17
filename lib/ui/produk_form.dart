import 'package:flutter/material.dart';
import 'package:buku/bloc/produk_bloc.dart';
import 'package:buku/model/produk.dart';
import 'package:buku/ui/produk_page.dart';
import 'package:buku/widget/warning_dialog.dart';

/// Form untuk menambah atau mengubah data Produk
class ProdukForm extends StatefulWidget {
  final Produk? produk;

  ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH BUKU";
  String tombolSubmit = "SIMPAN";

  final Color _softOrange = const Color(0xFFFFB74D);

  final _kodeBukuController = TextEditingController();
  final _namaBukuController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _tahunTerbitController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupForm();
  }

  void _setupForm() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH BUKU";
        tombolSubmit = "UBAH";
        _kodeBukuController.text = widget.produk!.kodeBuku ?? '';
        _namaBukuController.text = widget.produk!.namaBuku ?? '';
        _penulisController.text = widget.produk!.penulis ?? '';
        _penerbitController.text = widget.produk!.penerbit ?? '';
        _tahunTerbitController.text =
            widget.produk!.tahunTerbit?.toString() ?? '';
        _deskripsiController.text = widget.produk!.deskripsi ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: _softOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeBukuTextField(),
                _namaBukuTextField(),
                _penulisTextField(),
                _penerbitTextField(),
                _tahunTerbitTextField(),
                _deskripsiTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.orange.shade50,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _kodeBukuTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Kode Buku"),
        controller: _kodeBukuController,
        validator: (value) => value!.isEmpty ? "Kode Buku harus diisi" : null,
      ),
    );
  }

  Widget _namaBukuTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Nama Buku"),
        controller: _namaBukuController,
        validator: (value) => value!.isEmpty ? "Nama Buku harus diisi" : null,
      ),
    );
  }

  Widget _penulisTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Penulis"),
        controller: _penulisController,
        validator: (value) => value!.isEmpty ? "Penulis harus diisi" : null,
      ),
    );
  }

  Widget _penerbitTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Penerbit"),
        controller: _penerbitController,
        validator: (value) => value!.isEmpty ? "Penerbit harus diisi" : null,
      ),
    );
  }

  Widget _tahunTerbitTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Tahun Terbit"),
        keyboardType: TextInputType.number,
        controller: _tahunTerbitController,
        validator: (value) =>
        value!.isEmpty ? "Tahun Terbit harus diisi" : null,
      ),
    );
  }

  Widget _deskripsiTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration("Deskripsi"),
        controller: _deskripsiController,
        maxLines: 3,
        validator: (value) => value!.isEmpty ? "Deskripsi harus diisi" : null,
      ),
    );
  }

  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _softOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate() && !_isLoading) {
            widget.produk != null ? _ubah() : _simpan();
          }
        },
      ),
    );
  }

  void _simpan() {
    setState(() => _isLoading = true);

    Produk produkBaru = Produk(
      kodeBuku: _kodeBukuController.text,
      namaBuku: _namaBukuController.text,
      penulis: _penulisController.text,
      penerbit: _penerbitController.text,
      tahunTerbit: int.tryParse(_tahunTerbitController.text),
      deskripsi: _deskripsiController.text,
    );

    ProdukBloc.addProduk(produk: produkBaru).then((success) {
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProdukPage()),
        );
      } else {
        _showError("Simpan gagal, silahkan coba lagi");
      }
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  void _ubah() {
    setState(() => _isLoading = true);

    Produk produkUpdate = Produk(
      id: widget.produk!.id,
      kodeBuku: _kodeBukuController.text,
      namaBuku: _namaBukuController.text,
      penulis: _penulisController.text,
      penerbit: _penerbitController.text,
      tahunTerbit: int.tryParse(_tahunTerbitController.text),
      deskripsi: _deskripsiController.text,
    );

    ProdukBloc.updateProduk(produk: produkUpdate).then((success) {
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProdukPage()),
        );
      } else {
        _showError("Permintaan ubah data gagal, silahkan coba lagi");
      }
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => WarningDialog(description: message),
    );
  }
}
