import 'package:flutter/material.dart';
import 'package:buku/bloc/registrasi_bloc.dart';
import 'package:buku/widget/success_dialog.dart';
import 'package:buku/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE0B2), // oranye sangat lembut
              Color(0xFFFFB74D), // oranye pastel
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              color: Colors.white,
              elevation: 10,
              shadowColor: Colors.orangeAccent.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 80,
                        color: Colors.deepOrangeAccent,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Buat Akun Baru",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _namaTextField(),
                      const SizedBox(height: 16),
                      _emailTextField(),
                      const SizedBox(height: 16),
                      _passwordTextField(),
                      const SizedBox(height: 16),
                      _konfirmasiPasswordTextField(),
                      const SizedBox(height: 24),
                      _buttonRegistrasi(),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sudah punya akun? Login di sini",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dekorasi input field
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
      filled: true,
      fillColor: Colors.orange.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Textfield Nama
  Widget _namaTextField() {
    return TextFormField(
      controller: _namaController,
      decoration: _inputDecoration("Nama Lengkap", Icons.person),
      validator: (value) {
        if (value!.length < 3) {
          return "Nama minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // Textfield Email
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration("Email", Icons.email),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return "Email harus diisi";
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) return "Email tidak valid";
        return null;
      },
    );
  }

  // Textfield Password
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: _inputDecoration("Password", Icons.lock),
      validator: (value) {
        if (value!.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // Textfield Konfirmasi Password
  Widget _konfirmasiPasswordTextField() {
    return TextFormField(
      controller: _konfirmasiController,
      obscureText: true,
      decoration: _inputDecoration("Konfirmasi Password", Icons.lock_outline),
      validator: (value) {
        if (value != _passwordController.text) {
          return "Konfirmasi password tidak sama";
        }
        return null;
      },
    );
  }

  // Tombol Registrasi
  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!_isLoading) _submit();
          }
        },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "DAFTAR",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 🔥 teks jadi putih
          ),
        ),
      ),
    );
  }

  // Fungsi Registrasi
  void _submit() {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    RegistrasiBloc.registrasi(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
