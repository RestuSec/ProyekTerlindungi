# watch-and-repair.ps1 - pemantau & perbaikan otomatis Proyek Terlindungi
# Dijalankan oleh Task Scheduler tiap 10 menit.

$ProjectDir = "C:\Users\Suran\Documents\ProyekTerlindungi"
$PauseMarker = Join-Path $ProjectDir ".pause-watch"
$LogFile = Join-Path $ProjectDir "watch-repair.log"
$GitExe = "C:\Program Files\Git\cmd\git.exe"
$OpenCodeExe = "C:\Users\Suran\AppData\Roaming\npm\opencode.cmd"

function Write-Log([string]$msg) {
    $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -LiteralPath $LogFile -Value $line
    Write-Host $line
}

if (Test-Path -LiteralPath $PauseMarker) {
    Write-Log "SKIP: marker .pause-watch ada, pemantauan dijeda (hapus file untuk melanjutkan)."
    exit 0
}

if (Get-Process -Name opencode -ErrorAction SilentlyContinue) {
    Write-Log "SKIP: opencode sedang berjalan (sesi interaktif aktif), tidak ingin mengganggu."
    exit 0
}

Set-Location -LiteralPath $ProjectDir

$status = & $GitExe status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Log "OK: tidak ada perubahan. Proyek bersih."
    exit 0
}

Write-Log "TERDETEKSI perubahan yang belum di-commit:"
$status | ForEach-Object { Write-Log "  $_" }

$prompt = @"
Proyek di direktori ini adalah 'Proyek Terlindungi'. Ada perubahan yang belum di-commit
(silakan cek 'git status' dan 'git diff'). Periksa apakah perubahan itu sah atau mencurigakan.
Ikuti aturan di AGENTS.md: pulihkan (git restore) hanya perubahan mencurigakan/berbahaya,
biarkan perubahan sah, JANGAN commit, lalu laporkan ringkas apa yang dilakukan.
"@

try {
    $out = & $OpenCodeExe run $prompt 2>&1 | Out-String
    $preview = $out
    if ($preview.Length -gt 1500) { $preview = $preview.Substring(0, 1500) + "..." }
    Write-Log "AGENT OUTPUT:"
    Write-Log $preview
} catch {
    Write-Log "ERROR saat menjalankan opencode: $_"
}

$final = & $GitExe status --porcelain
if ([string]::IsNullOrWhiteSpace($final)) {
    Write-Log "HASIL: proyek bersih kembali - perubahan tak sah dipulihkan."
} else {
    Write-Log "HASIL: masih ada perubahan (dibiarkan agent karena sah):"
    $final | ForEach-Object { Write-Log "  $_" }
}
