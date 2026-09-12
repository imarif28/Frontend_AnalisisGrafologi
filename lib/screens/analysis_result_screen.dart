import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/analysis_provider.dart';
import '../widgets/bounding_box_painter.dart';
import '../widgets/error_dialog.dart';

// ============================================================
// Definisi Kategori untuk Detail Deteksi
// ============================================================
const _detectionCategories = [
  {
    'title': 'Awal Garis',
    'icon': Icons.login,
    'keys': ['awal_garis_dari_atas', 'awal_garis_dari_bawah'],
    'labels': ['Awal Garis dari Atas', 'Awal Garis dari Bawah'],
  },
  {
    'title': 'Ukuran Huruf Pertama',
    'icon': Icons.format_size,
    'keys': ['huruf_pertama_besar'],
    'labels': ['Huruf Pertama Besar'],
  },
  {
    'title': 'Bentuk Huruf Pertama',
    'icon': Icons.text_fields,
    'keys': [
      'huruf_pertama_lingkaran',
      'huruf_pertama_segitiga',
      'huruf_pertama_lengkung_atas',
      'huruf_pertama_garis_tegas',
    ],
    'labels': [
      'Huruf Pertama Lingkaran',
      'Huruf Pertama Segitiga',
      'Huruf Pertama Melengkung ke Atas',
      'Huruf Pertama Garis Tegas',
    ],
  },
  {
    'title': 'Karakteristik Garis',
    'icon': Icons.timeline,
    'keys': [
      'garis_bawah',
      'garis_berbalik_ke_belakang',
      'coretan_badan',
      'pertemuan_garis',
    ],
    'labels': [
      'Garis Bawah',
      'Garis Berbalik ke Belakang',
      'Coretan pada Badan Tanda Tangan',
      'Pertemuan Antar Garis',
    ],
  },
  {
    'title': 'Ciri Khas Lainnya',
    'icon': Icons.auto_awesome,
    'keys': ['jarak_kosong', 'ornamen'],
    'labels': ['Jarak Kosong', 'Ornamen'],
  },
  {
    'title': 'Ujung Garis',
    'icon': Icons.logout,
    'keys': ['ujung_garis_ke_atas'],
    'labels': ['Ujung Garis ke Atas'],
  },
];

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  ui.Image? _uiImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final provider = Provider.of<AnalysisProvider>(context, listen: false);
      if (provider.selectedImage == null) return;

      final bytes = await provider.selectedImage!.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _uiImage = frame.image;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          'Gambar gagal dimuat atau memori tidak mencukupi.',
        );
      }
    }
  }

  // ─── Builds one confidence bar item ───────────────────────
  Widget _buildConfidenceItem(String label, double confidence) {
    final bool detected = confidence >= 0.5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: detected ? FontWeight.w600 : FontWeight.normal,
                    color: detected ? Colors.black87 : Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(confidence * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: detected ? FontWeight.bold : FontWeight.w400,
                  color: detected
                      ? const Color(0xFF2B9A8F)
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: confidence,
            backgroundColor: Colors.grey.shade100,
            color: detected ? const Color(0xFF2B9A8F) : Colors.grey.shade300,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  // ─── Builds all categorized sections ──────────────────────
  List<Widget> _buildCategorizedDetections(
    BuildContext context,
    Map<String, double> allConfidences,
  ) {
    List<Widget> sections = [];

    for (final cat in _detectionCategories) {
      final catKeys = cat['keys'] as List<String>;
      final catLabels = cat['labels'] as List<String>;

      // Build items for this category
      List<Widget> items = [];
      bool anyDetected = false;
      for (int i = 0; i < catKeys.length; i++) {
        final key = catKeys[i];
        final confidence = allConfidences[key] ?? 0.0;
        if (confidence >= 0.5) anyDetected = true;
        items.add(_buildConfidenceItem(catLabels[i], confidence));
      }

      sections.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: anyDetected
                    ? const Color(0xFF2B9A8F).withValues(alpha: 0.3)
                    : Colors.grey.shade200,
              ),
              boxShadow: anyDetected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2B9A8F).withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        size: 16,
                        color: anyDetected
                            ? const Color(0xFF2B9A8F)
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: anyDetected
                              ? const Color(0xFF2B9A8F)
                              : Colors.grey.shade500,
                        ),
                      ),
                      if (anyDetected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B9A8F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Terdeteksi',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 16),
                  ...items,
                ],
              ),
            ),
          ),
        ),
      );
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Hasil Analisis',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, child) {
          if (provider.result == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final result = provider.result!;

          // Get unique detected classes for chip filters
          final uniqueClasses = result.detections
              .map((e) => e.className)
              .toSet()
              .toList();
          uniqueClasses.sort();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image with Bounding Boxes
                if (_uiImage != null)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: _uiImage!.width / _uiImage!.height,
                          child: CustomPaint(
                            painter: BoundingBoxPainter(
                              image: _uiImage!,
                              detections: result.detections,
                              visibleClasses: provider.visibleClasses,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),

                // 2. Chip Filters + Hint Note
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (uniqueClasses.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: uniqueClasses.map((className) {
                            final isSelected = provider.visibleClasses.contains(
                              className,
                            );
                            return FilterChip(
                              label: Text(
                                className.replaceAll('_', ' '),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                provider.toggleClassVisibility(className);
                              },
                              selectedColor: const Color(0xFF2B9A8F),
                              backgroundColor: Colors.grey.shade100,
                              checkmarkColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                            );
                          }).toList(),
                        ),
                      if (uniqueClasses.isEmpty)
                        Text(
                          'Tidak ada pola grafologi yang terdeteksi.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      if (uniqueClasses.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Ketuk label di atas untuk menampilkan atau menyembunyikan kotak deteksi pada gambar. Nonaktifkan label lain untuk fokus mengamati satu pola saja.',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: Colors.grey.shade400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Personality Narrative Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology_outlined,
                              color: Color(0xFF2B9A8F),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Interpretasi Kepribadian',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result.narrative,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 4. Detail Deteksi (Categorized)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Deteksi',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ..._buildCategorizedDetections(context, result.allConfidences),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
