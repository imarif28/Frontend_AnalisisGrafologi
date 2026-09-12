import 'package:flutter/material.dart';

class WireframeAnalysisResultScreen extends StatelessWidget {
  const WireframeAnalysisResultScreen({super.key});

  Widget _buildPlaceholderBox({double? width, required double height}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildCategoryBox(String title, int itemCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                _buildPlaceholderBox(width: 140, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 2, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            ...List.generate(
              itemCount,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPlaceholderBox(width: 120, height: 12),
                        _buildPlaceholderBox(width: 30, height: 12),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPlaceholderBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: _buildPlaceholderBox(width: 180, height: 20),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image area
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CrossPainter(),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // 2. Interactive chips
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  6, // representing the unique classes
                  (index) => Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Narrative Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildPlaceholderBox(width: 160, height: 16),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildPlaceholderBox(height: 12),
                    const SizedBox(height: 8),
                    _buildPlaceholderBox(height: 12),
                    const SizedBox(height: 8),
                    _buildPlaceholderBox(height: 12),
                    const SizedBox(height: 8),
                    _buildPlaceholderBox(width: 200, height: 12),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Detail Detections Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPlaceholderBox(width: 120, height: 20),
            ),
            const SizedBox(height: 12),

            // Detections Categories (6 categories)
            _buildCategoryBox('Awal Garis', 2),
            _buildCategoryBox('Ukuran Huruf Pertama', 1),
            _buildCategoryBox('Bentuk Huruf Pertama', 4),
            _buildCategoryBox('Karakteristik Garis', 4),
            _buildCategoryBox('Ciri Khas Lainnya', 2),
            _buildCategoryBox('Ujung Garis', 1),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
