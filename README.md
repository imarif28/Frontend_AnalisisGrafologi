# Frontend Analisis Grafologi - Mobile App

Ini adalah aplikasi mobile Flutter untuk analisis kepribadian berbasis grafologi tanda tangan.

## Fitur
- Unggah foto tanda tangan melalui kamera atau galeri
- Analisis pola grafologi menggunakan model YOLOv8 (via backend API)
- Visualisasi *bounding box* pada pola tanda tangan yang terdeteksi
- Interpretasi kepribadian berdasarkan pola grafologi
- Filter tampilan *bounding box* per kategori pola
- Kebijakan privasi data terintegrasi dalam alur unggah

## Documentation
<div align="center">
<img src="https://drive.google.com/uc?export=view&id=1aGOmg5ubQ0xmIW_XrVKIxW4aVVkQELjt" width="600" alt="Gambar1">
<img src="https://drive.google.com/uc?export=view&id=1TgX20WwOmdn36AV0rOE6T4xX5GQlDU7H" width="600" alt="Gambar2">
<img src="https://drive.google.com/uc?export=view&id=1QXGk0m3O6S4dvVf3XcfHfkadXTkLOFVN" width="600" alt="Gambar3">
<img src="https://drive.google.com/uc?export=view&id=1a5TR7t16FngTJEGom1YYN_7Umx2clRVz" width="600" alt="Gambar4">
<img src="https://drive.google.com/uc?export=view&id=1pQNR9T0Y6NOvJAoQwpOtweNS7ppKtfHH" width="600" alt="Gambar5">
</div>

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

