import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGuideDialog extends StatelessWidget {
  final ImageSource source;
  final void Function(ImageSource) onConfirm;

  const PhotoGuideDialog({
    super.key,
    required this.source,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context,
    ImageSource source,
    void Function(ImageSource) onConfirm,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PhotoGuideDialog(source: source, onConfirm: onConfirm),
    );
  }

  static const List<Map<String, dynamic>> _rules = [
    {
      'icon': Icons.stay_current_portrait,
      'text': 'Posisikan foto secara vertikal (portrait)',
    },
    {
      'icon': Icons.crop_free,
      'text': 'Pastikan seluruh tanda tangan tidak terpotong',
    },
    {
      'icon': Icons.rectangle_outlined,
      'text': 'Gunakan latar belakang putih polos — tanpa garis atau warna lain',
    },
    {
      'icon': Icons.edit_outlined,
      'text': 'Tulis tanda tangan menggunakan pulpen/pena berwarna hitam saja',
    },
    {
      'icon': Icons.wb_sunny_outlined,
      'text': 'Pastikan pencahayaan cukup agar tanda tangan terlihat jelas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isCamera = source == ImageSource.camera;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Color(0xFF2B9A8F), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Panduan Foto Tanda Tangan',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close,
                        color: Colors.grey.shade400, size: 20),
                  ),
                ],
              ),

              const Divider(height: 20),

              // ── Rules List ──────────────────────────────────────
              ...List.generate(_rules.length, (i) {
                final rule = _rules[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F3F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              rule['icon'] as IconData,
                              size: 18,
                              color: const Color(0xFF2B9A8F),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rule['text'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.45,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Divider(height: 20),

              // ── Contoh Foto ──────────────────────────────────────
              Text(
                'Contoh Foto',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Benar
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/benar.jpg',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF2B9A8F), size: 15),
                              const SizedBox(width: 4),
                              Text(
                                'Benar',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2B9A8F),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Salah
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/salah.jpg',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cancel_rounded,
                                  color: Colors.redAccent, size: 15),
                              const SizedBox(width: 4),
                              Text(
                                'Salah',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Confirm Button ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm(source);
                  },
                  icon: Icon(
                    isCamera ? Icons.camera_alt_rounded : Icons.photo_library_rounded,
                    size: 19,
                  ),
                  label: Text(
                    isCamera ? 'Buka Kamera' : 'Pilih dari Galeri',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B9A8F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
