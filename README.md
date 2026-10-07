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
  <table>
    <tr>
      <td><img src="https://drive.google.com/uc?export=view&id=1pHbMvZuJMo-CVKReL5PVFZZZWY3HFoIv" width="760" alt="Gambar1"></td>
      <td><img src="https://drive.google.com/uc?export=view&id=1gTGst-WufdDSARiyyh4cqWs4dKv2tXm1" width="760" alt="Gambar2"></td>
      <td><img src="https://drive.google.com/uc?export=view&id=1XWq7TYsfra0eAVEsa1UGNmS5_e6mwyUD" width="760" alt="Gambar3"></td>
    </tr>
  </table>
  <table>
    <tr>
      <td><img src="https://drive.google.com/uc?export=view&id=1zCniBVQdSauG0UbkILDZ6gxxdVJLtSdA" width="760" alt="Gambar4"></td>
      <td><img src="https://drive.google.com/uc?export=view&id=1HhEl6GYojNMBOQ99f_z8W5DvSBvTEVoz" width="760" alt="Gambar5"></td>
    </tr>
  </table>
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

