// Service worker Blok Blas: network-first biar update langsung kepakai,
// fallback ke cache biar tetap bisa dimainin offline.
const CACHE = 'blokblas-v2';
const AWAL = ['./', 'index.html', 'manifest.webmanifest', 'icon-192.png', 'icon-512.png'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(AWAL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (e) => {
  if (e.request.method !== 'GET') return;
  // file game sendiri: selalu tanya server (no-cache), karena GitHub Pages bikin browser
  // nyimpen cache 10 menit dan HP jadi masih jalanin versi lama setelah update
  const milikSendiri = new URL(e.request.url).origin === self.location.origin;
  e.respondWith(
    fetch(e.request, milikSendiri ? { cache: 'no-cache' } : undefined)
      .then((res) => {
        if (res.ok || res.type === 'opaque') {
          const salinan = res.clone();
          caches.open(CACHE).then((c) => c.put(e.request, salinan));
        }
        return res;
      })
      .catch(() => caches.match(e.request, { ignoreSearch: true }).then((r) => r || caches.match('index.html')))
  );
});
