import 'package:flutter/material.dart';

class WireframePhotoGuideDialog extends StatelessWidget {
  const WireframePhotoGuideDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const WireframePhotoGuideDialog(),
    );
  }

  Widget _buildWireframeImagePlaceholder(String title, bool isCorrect) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size.fromHeight(150),
                painter: _CrossPainter(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 15, height: 15, color: Colors.grey.shade300),
            const SizedBox(width: 4),
            Container(
              width: 40,
              height: 12,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWireframeListItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 150,
                  height: 12,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Row(
                children: [
                  Container(width: 22, height: 22, color: Colors.grey.shade300),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(width: 20, height: 20, color: Colors.grey.shade300),
                  ),
                ],
              ),
              const Divider(height: 20),

              // ── Rules List ──────────────────────────────────────
              ...List.generate(5, (index) => _buildWireframeListItem()),

              const Divider(height: 20),

              // ── Contoh Foto ──────────────────────────────────────
              Container(
                width: 80,
                height: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 10),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildWireframeImagePlaceholder('Benar', true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildWireframeImagePlaceholder('Salah', false)),
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
                  },
                  icon: Container(width: 20, height: 20, color: Colors.grey.shade300),
                  label: Container(
                    width: 100,
                    height: 14,
                    color: Colors.grey.shade400,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.grey.shade400, width: 2),
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
