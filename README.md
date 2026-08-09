# Proyek Terlindungi

Proyek demo untuk mekanisme perlindungan kode otomatis:

- **Git** sebagai jaring pengaman (baseline commit).
- **watch-and-repair.ps1** mendeteksi perubahan tak wajar.
- **opencode run** memperbaiki/memulihkan perubahan tanpa izin.
- **AGENTS.md** berisi aturan yang dipatuhi agent saat bekerja di proyek ini.

## Persyaratan

- **Git** — [git-scm.com](https://git-scm.com/downloads)
- **Node.js** — untuk opencode CLI
- **opencode CLI** — `npm install -g opencode-ai`
- Akun yang sudah login untuk opencode (model aktif).

## Cara Menjalankan

### 1. Clone repo

```bash
git clone https://github.com/RestuSec/ProyekTerlindungi.git
cd ProyekTerlindungi
```

### 2. Jalankan watcher sekali (tes manual)

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\watch-and-repair.ps1
```

Membaca `git status`. Jika tidak ada perubahan: log "OK: proyek bersih".
Jika ada perubahan tak di-commit: memanggil `opencode run` untuk memeriksa
dan memulihkan perubahan yang mencurigakan.

> Opsi tes: tambahkan `-AllowWhileActive` untuk memaksa berjalan meski
> sesi opencode interaktif sedang aktif.

### 3. Jadwalkan otomatis (Windows Task Scheduler)

```powershell
$action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PWD\watch-and-repair.ps1`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10)
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
Register-ScheduledTask -TaskName "ProyekTerlindungi-Watch" -Action $action -Trigger $trigger -Settings $settings -Force
```

Cek terjadwal:

```powershell
Get-ScheduledTask -TaskName "ProyekTerlindungi-Watch" | Select State
```

### 4. Jeda / lanjutkan pemantauan

- **Jeda:** buat file `.pause-watch` di folder proyek:

```powershell
New-Item -ItemType File -Path .\.pause-watch
```

- **Lanjut:** hapus file tersebut:

```powershell
Remove-Item .\.pause-watch
```

### 5. Lihat log hasil

Semua aktivitas watcher tercatat di `watch-repair.log` (diabaikan Git).

```powershell
Get-Content .\watch-repair.log -Tail 30
```

## Alur perlindungan

1. Commit perubahan sah dengan pesan jelas:

```bash
git add .
git commit -m "deskripsi pekerjaan"
git push
```

2. Watcher berjalan tiap 10 menit.
3. Perubahan yang belum di-commit dan mencurigakan → agent memulihkan ke baseline.
4. Agent **tidak** me-commit hasil perbaikan; Anda yang memutuskan.

## Aturan penting

- Commit pekerjaan sendiri secara rutin agar tidak dianggap mencurigakan.
- Watcher berhenti jika sesi opencode interaktif sedang aktif (tidak mengganggu kerja Anda).
- Backup di luar mesin tetap disarankan untuk keamanan ekstra.
