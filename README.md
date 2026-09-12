# Frontend Analisis Grafologi - Mobile App

Ini adalah aplikasi mobile Flutter untuk analisis kepribadian berbasis grafologi tanda tangan.

## Fitur
- Unggah foto tanda tangan melalui kamera atau galeri
- Analisis pola grafologi menggunakan model YOLOv8 (via backend API)
- Visualisasi *bounding box* pada pola tanda tangan yang terdeteksi
- Interpretasi kepribadian berdasarkan pola grafologi
- Filter tampilan *bounding box* per kategori pola
- Kebijakan privasi data terintegrasi dalam alur unggah

## Teknologi
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **HTTP Client**: `http` package
- **Image Picker**: `image_picker` package
- **Backend**: FastAPI (lihat repositori [Backend Analisis Grafologi](https://github.com/imarif28/fast_api_skripsi))

## Cara Menjalankan

### Prasyarat
- Flutter SDK ≥ 3.0.0
- Android Studio / VS Code
- Perangkat Android atau emulator

### Langkah Instalasi
```bash
# Clone repositori
git clone https://github.com/imarif28/Frontend_AnalisisGrafologi.git
cd Frontend_AnalisisGrafologi

# Install dependencies
flutter pub get

# Jalankan aplikasi (mode debug)
flutter run
```

### Build APK Release
```bash
flutter build apk --release
```
File APK akan tersimpan di `build/app/outputs/flutter-apk/app-release.apk`

## Konfigurasi Server
URL server backend telah dikonfigurasi di `lib/providers/analysis_provider.dart`:
```dart
final String _baseUrl = 'http://130.211.231.136:8001';
```
Sesuaikan dengan alamat server backend Anda jika diperlukan.
