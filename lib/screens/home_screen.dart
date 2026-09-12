import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/analysis_provider.dart';
import '../widgets/error_dialog.dart';
import '../widgets/photo_guide_dialog.dart';
import '../widgets/skeleton_item.dart';
import 'analysis_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State untuk privacy policy checkbox & expand/collapse
  bool _isPrivacyAgreed = false;
  bool _isPrivacyExpanded = false;

  void _handlePickImage(
    BuildContext context,
    AnalysisProvider provider,
    ImageSource source,
  ) async {
    // Reset persetujuan privasi setiap kali gambar baru dipilih
    setState(() {
      _isPrivacyAgreed = false;
      _isPrivacyExpanded = false;
    });

    PhotoGuideDialog.show(context, source, (confirmedSource) async {
      try {
        await provider.pickImage(confirmedSource);
      } catch (e) {
        if (context.mounted) {
          ErrorDialog.show(context, e.toString().replaceAll('Exception: ', ''));
        }
      }
    });
  }

  void _processImage(BuildContext context, AnalysisProvider provider) async {
    if (provider.selectedImage == null) return;

    await provider.analyzeSignature();

    if (provider.errorMessage == null && provider.result != null) {
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalysisResultScreen()),
        );
        // Kembali dari halaman hasil → reset ke kondisi awal (halaman bersih)
        provider.reset();
        setState(() {
          _isPrivacyAgreed = false;
          _isPrivacyExpanded = false;
        });
      }
    } else {
      if (context.mounted) {
        ErrorDialog.show(
          context,
          provider.errorMessage ?? 'Terjadi kesalahan saat menganalisis.',
        );
      }
    }
  }

  /// Widget Privacy Policy yang dapat di-expand/collapse
  Widget _buildPrivacyConsent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris Checkbox + Teks Ringkas + Tombol Expand ──
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _isPrivacyExpanded = !_isPrivacyExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Checkbox
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isPrivacyAgreed,
                      activeColor: const Color(0xFF2B9A8F),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (val) {
                        setState(() {
                          _isPrivacyAgreed = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Teks ringkas (selalu tampil)
                  Expanded(
                    child: Text(
                      'Saya setuju untuk mengunggah foto tanda tangan ini.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  // Ikon expand/collapse
                  Icon(
                    _isPrivacyExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── Bagian yang di-expand: detail kebijakan privasi ──
          if (_isPrivacyExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security_rounded,
                          color: Color(0xFF2B9A8F), size: 15),
                      const SizedBox(width: 6),
                      Text(
                        'Kebijakan Privasi Data',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2B9A8F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _privacyPoint(1,
                    'Foto tanda tangan Anda merupakan data sensitif yang berkaitan dengan identitas pribadi.',
                  ),
                  _privacyPoint(2,
                    'Data hanya digunakan untuk keperluan analisis pola grafologi dalam rangka penelitian skripsi dan tidak akan digunakan untuk tujuan lain.',
                  ),
                  _privacyPoint(3,
                    'Data Anda tidak akan dibagikan, dijual, atau diteruskan kepada pihak ketiga manapun.',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _privacyPoint(int number, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
          Expanded(
            child: Text(
              desc,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Analisis Grafologi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon or Illustration
                  Image.asset('assets/logo.png', height: 160),
                  const SizedBox(height: 32),

                  Text(
                    'Unggah Tanda Tangan',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pilih foto tanda tangan Anda untuk dianalisis pola grafologi dan interpretasi kepribadiannya.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  if (provider.selectedImage != null) ...[
                    // ── Pratinjau Gambar ──────────────────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        provider.selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (provider.isLoading) ...[
                      const SizedBox(height: 16),
                      // Animasi seolah-olah sedang mengetik/membangun hasil
                      const SkeletonItem(
                        width: 180,
                        height: 20,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 16),
                      const SkeletonItem(width: double.infinity, height: 12),
                      const SizedBox(height: 8),
                      const SkeletonItem(width: double.infinity, height: 12),
                      const SizedBox(height: 8),
                      const SkeletonItem(width: 220, height: 12),
                    ] else ...[
                      // ── Privacy Policy Checkbox (Expandable) ─────────────
                      _buildPrivacyConsent(),
                      const SizedBox(height: 16),

                      // ── Tombol Analisa Sekarang ───────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isPrivacyAgreed
                              ? () => _processImage(context, provider)
                              : null, // Dinonaktifkan jika belum setuju
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B9A8F),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            disabledForegroundColor: Colors.grey.shade500,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Analisis Sekarang',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : () => _handlePickImage(
                                    context,
                                    provider,
                                    ImageSource.camera,
                                  ),
                            icon: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            label: Text(
                              'Kamera',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          TextButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : () => _handlePickImage(
                                    context,
                                    provider,
                                    ImageSource.gallery,
                                  ),
                            icon: Icon(
                              Icons.photo_library,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            label: Text(
                              'Galeri',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _handlePickImage(
                              context,
                              provider,
                              ImageSource.camera,
                            ),
                            icon: const Icon(Icons.camera_alt),
                            label: Text(
                              'Kamera',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B9A8F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _handlePickImage(
                              context,
                              provider,
                              ImageSource.gallery,
                            ),
                            icon: const Icon(Icons.photo_library),
                            label: Text(
                              'Galeri',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2B9A8F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Color(0xFF2B9A8F),
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
