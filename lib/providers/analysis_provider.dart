import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/detection_result.dart';

class AnalysisProvider with ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  DetectionResult? _result;
  DetectionResult? get result => _result;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Set of classes that user toggled to show bounding boxes
  Set<String> _visibleClasses = {};
  Set<String> get visibleClasses => _visibleClasses;

  // GCP server (production) — gambar tidak disimpan di server
  final String _baseUrl = 'http://130.211.231.136:8001';
  String get baseUrl => _baseUrl;

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1500,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _result = null; // reset result
        _errorMessage = null;
        _visibleClasses.clear();
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Gagal membuka kamera/galeri. Pastikan izin akses telah diberikan.');
    }
  }

  Future<void> analyzeSignature() async {
    if (_selectedImage == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/analyze-signature'),
      );
      
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        _result = DetectionResult.fromJson(jsonResponse);
        
        // Show all bounding boxes by default
        if (_result != null) {
          _visibleClasses = _result!.detections.map((d) => d.className).toSet();
        }
      } else {
        try {
          final errorMap = jsonDecode(response.body);
          final detail = errorMap['detail'];
          if (detail is String) {
            _errorMessage = detail;
          } else if (detail is List && detail.isNotEmpty) {
            _errorMessage = 'Data tidak valid: ${detail[0]['msg'] ?? 'Periksa kembali input Anda.'}';
          } else if (response.statusCode == 404) {
            _errorMessage = 'API tidak ditemukan (Error 404). Pastikan URL server sudah benar.';
          } else if (response.statusCode >= 500) {
            _errorMessage = 'Terjadi kesalahan internal pada server (Error ${response.statusCode}).';
          } else {
            _errorMessage = 'Terjadi kesalahan pada server (Kode: ${response.statusCode})';
          }
        } catch (_) {
          if (response.statusCode == 404) {
            _errorMessage = 'API tidak ditemukan (Error 404). Pastikan URL server sudah benar.';
          } else if (response.statusCode >= 500) {
            _errorMessage = 'Terjadi kesalahan internal pada server (Error ${response.statusCode}).';
          } else {
            _errorMessage = 'Gagal memproses respons dari server (Kode: ${response.statusCode})';
          }
        }
      }
    } catch (e) {
      debugPrint('Connection Error: $e');
      if (e is TimeoutException) {
        _errorMessage = 'Waktu koneksi habis. Server terlalu lama merespons. Pastikan server backend sedang berjalan.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        _errorMessage = 'Gagal terhubung ke server. Pastikan perangkat Anda terhubung ke internet.';
      } else {
        _errorMessage = 'Terjadi kesalahan: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleClassVisibility(String className) {
    if (_visibleClasses.contains(className)) {
      _visibleClasses.remove(className);
    } else {
      _visibleClasses.add(className);
    }
    notifyListeners();
  }

  void reset() {
    _selectedImage = null;
    _result = null;
    _errorMessage = null;
    _visibleClasses.clear();
    notifyListeners();
  }
}
