# 🎬 Aplikasi Informasi Film (TMDB API)

Aplikasi Informasi Film adalah aplikasi yang menampilkan berbagai informasi film secara real-time dengan memanfaatkan **API dari The Movie Database (TMDB)**.
Aplikasi ini memungkinkan pengguna untuk melihat daftar film populer, detail film, rating, genre, dan informasi lainnya dengan tampilan yang interaktif.

---

## 🚀 Fitur Utama

* 🔍 Menampilkan daftar film populer
* 🎞️ Detail film (judul, rating, sinopsis, tanggal rilis)
* ⭐ Informasi rating dan genre film
* 📅 Film terbaru (Now Playing / Upcoming)
* 🔎 Fitur pencarian film
* 🖼️ Poster film dari TMDB

---

## 🛠️ Teknologi yang Digunakan

* Flutter
* REST API (TMDB)
* HTTP Request
* JSON Parsing
* Material UI

---

## 🌐 Sumber API

Data film diambil dari:
👉 https://www.themoviedb.org/
👉 https://developer.themoviedb.org/

---

## ⚙️ Cara Menjalankan Project

```bash
git clone https://github.com/username/nama-repo.git
cd nama-repo/aplikasi
flutter pub get
flutter run
```

---

## 🔑 Konfigurasi API Key

1. Daftar akun di TMDB
2. Generate API Key
3. Simpan API Key di file konfigurasi (misalnya `api_service.dart`)

Contoh:

```dart
const apiKey = "YOUR_API_KEY";
```

---

## 📸 Tampilan Aplikasi

### Halaman Beranda

![Login](Screenshots/gambar(2).png)

### Detail Film

![Detail](screenshots/detail.png)

### Halaman Home

![Detail](screenshots/detail.png)

---

## 📂 Struktur Project

```
aplikasi/
├── lib/
├── assets/
├── models/
├── services/
└── main.dart
```

---

## 🎯 Tujuan Pengembangan

Project ini dibuat untuk:

* Pembelajaran integrasi REST API
* Memahami pengolahan data JSON
* Implementasi UI Flutter
* Portfolio pengembangan aplikasi mobile

---

## 👨‍💻 Author

**Tresna Nas**



