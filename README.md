# Blok Blas

Game puzzle blok sederhana: tarik potongan blok ke papan 8x8, penuhi satu baris atau kolom untuk menghapusnya. Satu file HTML, tanpa library JS, tanpa build (font Baloo 2 diambil dari Google Fonts, ada fallback kalau offline).

Main langsung: **https://istu2174.github.io/blok-blas/**

## Install di HP

Buka link di atas pakai Chrome (Android) lalu pilih **Tambahkan ke layar utama / Install app**. Di iPhone: Safari → Share → **Add to Home Screen**. Setelah ter-install, game bisa dimainkan offline.

## Akun & skill

- Masuk atau daftar (nama + kata sandi) sebelum main. Akun & skor terbaik disimpan online di [Supabase](https://supabase.com), jadi sama di HP maupun laptop.
- Skill 🧹 **Kosongkan papan** muncul saat tidak ada blok yang muat: papan dikosongkan, skor tetap lanjut.
- Pemain biasa punya 3x skill per game. Setelah habis, game over dan mulai lagi dari 0.
- Admin punya skill tanpa batas (nggak bisa kalah). Status admin diatur di database, bukan dari nama akun.
- Catatan: logika game jalan di browser, jadi skor masih bisa dicurangi lewat devtools. Status admin nggak bisa diubah dari browser.

### Setup Supabase (sekali, buat pemilik)

1. Bikin project gratis di supabase.com.
2. SQL Editor → jalankan [`supabase/schema.sql`](supabase/schema.sql).
3. Authentication → Sign In / Providers → Email → matikan **Confirm email** (login pakai nama, bukan email asli).
4. Isi `SUPABASE_URL` dan `SUPABASE_KEY` (anon/publishable key) di `index.html`.
5. Daftar akun admin lewat game, lalu di SQL Editor: `update public.profiles set is_admin = true where username = 'admin';`

## Cara main

- Tarik salah satu dari tiga blok di bawah ke papan (mouse atau jari). Di layar sentuh, blok diangkat sedikit di atas jari biar kelihatan.
- Berubah pikiran? Tarik blok balik ke bar bawah buat batal.
- Blok hanya bisa ditaruh kalau semua selnya kosong dan masih di dalam papan.
- Baris atau kolom yang penuh langsung terhapus dan dapat skor.
- Hapus beberapa baris sekaligus / beruntun untuk kombo yang lebih besar.
- Game selesai kalau tidak ada blok tersisa yang muat.
- Tombol `↻` atau tombol `R` untuk main ulang, `🔊` untuk suara on/off.

## Jalanin lokal

Buka `index.html` langsung di browser, atau:

```bash
npx http-server . -p 8080
```

## Struktur

```
index.html             # game: HTML, CSS, dan JS
manifest.webmanifest   # info aplikasi buat install (PWA)
sw.js                  # service worker: cache biar bisa offline
icon-192.png, icon-512.png
```

Teknis singkat: papan disimpan sebagai array 64 elemen, bentuk blok sebagai daftar koordinat, seret pakai Pointer Events (jadi jalan di mouse maupun sentuh), preview penempatan dihitung dari posisi ghost yang diskalakan ke ukuran sel papan.
