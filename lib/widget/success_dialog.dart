import 'package:flutter/material.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class SuccessDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({Key? key, this.description, this.okClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 8.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Consts.padding,
        vertical: Consts.padding * 1.5,
      ),
      margin: const EdgeInsets.only(top: Consts.avatarRadius / 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0), // latar oranye lembut
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding * 1.2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Judul sukses
          const Text(
            "BERHASIL!",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A00), // oranye lembut
            ),
          ),
          const SizedBox(height: 12.0),

          // Deskripsi pesan
          Text(
            description ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24.0),

          // Tombol OK
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                if (okClick != null) okClick!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A00), // oranye lembut
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white, // tulisan putih
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
