# Blok Blas

Game puzzle blok sederhana: tarik potongan blok ke papan 8x8, penuhi satu baris atau kolom untuk menghapusnya. Satu file HTML, tanpa library JS, tanpa build (font Baloo 2 diambil dari Google Fonts, ada fallback kalau offline).

Main langsung: **https://istu2174.github.io/blok-blas/**

## Cara main

- Tarik salah satu dari tiga blok di bawah ke papan (mouse atau jari). Di layar sentuh, blok diangkat sedikit di atas jari biar kelihatan.
- Blok hanya bisa ditaruh kalau semua selnya kosong dan masih di dalam papan.
- Baris atau kolom yang penuh langsung terhapus dan dapat skor.
- Hapus beberapa baris sekaligus / beruntun untuk kombo yang lebih besar.
- Game selesai kalau tidak ada blok tersisa yang muat.
- Tombol `↻` atau tombol `R` untuk main ulang, `🔊` untuk suara on/off.
- Skor terbaik disimpan di `localStorage` browser.

## Jalanin lokal

Buka `index.html` langsung di browser, atau:

```bash
npx http-server . -p 8080
```

## Struktur

```
index.html   # semua ada di sini: HTML, CSS, dan JS
```

Teknis singkat: papan disimpan sebagai array 64 elemen, bentuk blok sebagai daftar koordinat, seret pakai Pointer Events (jadi jalan di mouse maupun sentuh), preview penempatan dihitung dari posisi ghost yang diskalakan ke ukuran sel papan.
