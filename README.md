# Proyek Terlindungi

Proyek demo untuk mekanisme perlindungan kode otomatis:

- **Git** sebagai jaring pengaman (baseline commit).
- **watch-and-repair.ps1** mendeteksi perubahan tak wajar.
- **opencode run** memperbaiki/memulihkan perubahan tanpa izin.
- **AGENTS.md** berisi aturan yang dipatuhi agent saat bekerja di proyek ini.

## Alur perlindungan

1. Semua perubahan yang sah di-*commit* dengan pesan jelas.
2. Watcher berjalan tiap 10 menit via Task Scheduler.
3. Jika ada perubahan yang belum di-commit, agent memeriksa dan memulihkan perubahan yang mencurigakan.
