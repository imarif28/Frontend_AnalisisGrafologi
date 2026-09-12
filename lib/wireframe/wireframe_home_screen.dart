import 'package:flutter/material.dart';
import 'wireframe_photo_guide_dialog.dart';
import 'wireframe_analysis_result_screen.dart';

class WireframeHomeScreen extends StatefulWidget {
  const WireframeHomeScreen({super.key});

  @override
  State<WireframeHomeScreen> createState() => _WireframeHomeScreenState();
}

class _WireframeHomeScreenState extends State<WireframeHomeScreen> {
  bool _hasImage = false;
  bool _isLoading = false;
  bool _isPrivacyAgreed = false;
  bool _isPrivacyExpanded = false;

  Widget _box({double? width, required double height, double radius = 8}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }


  void _handlePickImage() {
    WireframePhotoGuideDialog.show(context);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _hasImage = true;
          _isPrivacyAgreed = false;
          _isPrivacyExpanded = false;
        });
      }
    });
  }

  void _processImage() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WireframeAnalysisResultScreen()),
        ).then((_) {
          if (mounted) {
            setState(() {
              _hasImage = false;
              _isPrivacyAgreed = false;
              _isPrivacyExpanded = false;
            });
          }
        });
      }
    });
  }

  /// Wireframe: Privacy Policy Checkbox (expandable)
  Widget _buildPrivacyConsent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris Checkbox + Label ringkas + ikon expand ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox placeholder
                GestureDetector(
                  onTap: () => setState(() => _isPrivacyAgreed = !_isPrivacyAgreed),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _isPrivacyAgreed ? Colors.grey.shade500 : Colors.white,
                      border: Border.all(color: Colors.grey.shade500, width: 2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: _isPrivacyAgreed
                        ? Icon(Icons.check, size: 12, color: Colors.grey.shade100)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                // Teks ringkas
                Expanded(child: _box(height: 13, radius: 4)),
                const SizedBox(width: 8),
                // Ikon expand/collapse
                GestureDetector(
                  onTap: () => setState(() => _isPrivacyExpanded = !_isPrivacyExpanded),
                  child: Icon(
                    _isPrivacyExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // ── Bagian expand: detail kebijakan privasi ──
          if (_isPrivacyExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header "Kebijakan Privasi Data" (ikon + teks abu)
                  Row(
                    children: [
                      Container(
                          width: 15, height: 15, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      _box(width: 130, height: 12, radius: 4),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Poin 1
                  _buildPrivacyPointWf(1),
                  // Poin 2
                  _buildPrivacyPointWf(2),
                  // Poin 3
                  _buildPrivacyPointWf(3),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacyPointWf(int n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 8, height: 10, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(height: 10, radius: 3),
                const SizedBox(height: 3),
                _box(width: n == 2 ? double.infinity : 200, height: 10, radius: 3),
              ],
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
        title: _box(width: 180, height: 20),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.grey),
        leading: IconButton(
          icon: Container(width: 20, height: 20, color: Colors.grey.shade300),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo Placeholder ─────────────────────────────────
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Container(
                      width: 40, height: 40, color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 32),

              // ── Judul & Deskripsi ─────────────────────────────────
              _box(width: 220, height: 24),
              const SizedBox(height: 12),
              _box(height: 14),
              const SizedBox(height: 4),
              _box(width: 240, height: 14),
              const SizedBox(height: 48),

              if (_hasImage) ...[
                // ── Pratinjau Citra ───────────────────────────────────
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomPaint(painter: _CrossPainter()),
                ),
                const SizedBox(height: 20),

                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  _box(width: 180, height: 20),
                  const SizedBox(height: 16),
                  _box(height: 12),
                  const SizedBox(height: 8),
                  _box(height: 12),
                  const SizedBox(height: 8),
                  _box(width: 220, height: 12),
                ] else ...[

                  // ── Privacy Policy Checkbox (Expandable) ─────────────
                  _buildPrivacyConsent(),
                  const SizedBox(height: 16),

                  // ── Tombol Analisis Sekarang ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPrivacyAgreed ? _processImage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPrivacyAgreed
                            ? Colors.grey.shade400
                            : Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: _isPrivacyAgreed
                                ? Colors.grey.shade500
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: _box(width: 140, height: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Tombol Ganti Gambar (Kamera | Galeri) ────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _outlineIconTextBtn(),
                      const SizedBox(width: 24),
                      _outlineIconTextBtn(),
                    ],
                  ),
                ],
              ] else ...[

                // ── Tombol Pilih Gambar Awal ──────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handlePickImage,
                        icon: Container(
                            width: 20, height: 20, color: Colors.grey.shade400),
                        label: _box(width: 80, height: 16),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                color: Colors.grey.shade400, width: 2),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handlePickImage,
                        icon: Container(
                            width: 20, height: 20, color: Colors.grey.shade400),
                        label: _box(width: 80, height: 16),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                color: Colors.grey.shade400, width: 2),
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
      ),
    );
  }

  Widget _outlineIconTextBtn() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 20, height: 20, color: Colors.grey.shade300),
        const SizedBox(width: 6),
        _box(width: 50, height: 13, radius: 4),
      ],
    );
  }
}

class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
