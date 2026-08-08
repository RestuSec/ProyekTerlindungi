# AGENTS.md — Aturan Perlindungan Proyek

Proyek ini dipantau oleh sistem perlindungan otomatis. Agent (opencode/Codex/Claude Code) wajib mematuhi protokol berikut.

## Prinsip
- Kode yang sudah di-commit adalah **baseline yang sah**.
- Perubahan yang tidak di-commit dan **tidak diminta pengguna** dianggap mencurigakan → pulihkan.
- Jangan menghapus, melewati, atau mengubah `watch-and-repair.ps1`, `AGENTS.md`, atau konfigurasi Task Scheduler tanpa instruksi tertulis dari pengguna.

## Ketika diminta memulihkan ("review dan perbaiki perubahan tak sah")
1. Jalankan `git status --porcelain` dan `git diff` untuk melihat perubahan.
2. Bedakan:
   - Perubahan sah (diminta pengguna / sesuai task) → biarkan.
   - Perubahan jahat/mencurigakan (backdoor, kredensial palsu, obfuscated code, hapus fitur tanpa izin) → **kembalikan ke baseline** dengan `git checkout -- <file>` atau `git restore`.
3. Jika ragu, jangan hapus — beri tahu pengguna dan minta keputusan.
4. Jangan commit hasil perbaikan; biarkan pengguna yang commit.

## Ketika melakukan tugas normal
- Kerjakan tugas sesuai instruksi.
- Setelah selesai, beri tahu pengguna untuk `git add` + `git commit` agar baseline tetap segar (menghindari watcher menganggap pekerjaan sah sebagai mencurigakan).
