# Catatan Praktikum M03

## Lingkungan Aktual
- VM Azure (East Asia), Ubuntu Server 24.04.5 LTS, kernel 7.0.0-1017-azure,
  Python 3.12
- 2 vCPU, 836 MiB RAM, disk 29 GB (OS disk), tanpa swap
- Modul menetapkan 1 vCPU, 1 GB RAM, disk 20 GB. Versi OS sudah sesuai
  modul (24.04). Selisih spesifikasi dicatat di ADR-0001.
- Paket: Gunicorn 26.2.0, Flask 3.1.3, Caddy 2.11.7 (repo resmi Caddy)

## Temuan dan Troubleshooting

### 1. Konfigurasi SSH bawaan VM berbeda dari target
- Gejala: pada VM baru, `50-cloud-init.conf` sudah berisi
  `PasswordAuthentication no` (VM dibuat dengan SSH key), tetapi
  `PermitRootLogin` masih `without-password` dan `AllowUsers` belum ada.
- Solusi: file hardening eksplisit `01-pti2802.conf` (PermitRootLogin no,
  PasswordAuthentication no, KbdInteractiveAuthentication no,
  AllowUsers cloudstudent). Dinamai 01 agar dibaca paling awal, karena
  OpenSSH memakai nilai pertama yang dibaca.
- Bukti: `sudo sshd -T` menampilkan nilai target. Login root dan login
  password ditolak dengan `Permission denied (publickey)`.

### 2. Log Gunicorn: Control server error
- Gejala: `[ERROR] Control server error: [Errno 13] Permission denied:
  '/home/cloudstudent'` pada log Gunicorn 26.2.0.
- Penyebab: `ProtectHome=true` pada systemd membatasi akses ke /home,
  sehingga control socket opsional Gunicorn tidak dapat dibuat.
- Dampak: tidak ada. Aplikasi tetap melayani request (/health = ok).
- Keputusan: dibiarkan karena fitur tersebut tidak dipakai dan proteksi
  ProtectHome dipertahankan.

### 3. Urutan kerja: kernel update sebelum hardening
- Setelah `apt full-upgrade`, kernel baru (7.0.0-1017-azure) menunggu
  reboot. Reboot dilakukan sebelum hardening SSH agar penyebab masalah
  mudah dilacak.

## Catatan Operasional
- `sudo` tidak meminta password pada VM Azure ini (user dibuat tanpa
  password, akses lewat SSH key).
- Deploy key GitHub dibuat khusus untuk VM ini, tanpa write access.

## Verifikasi Reboot
- Setelah `sudo reboot`: `cc-m03` dan `caddy` active otomatis, /health = ok.
- Tes eksternal dari laptop ke IP publik berhasil setelah reboot.

## Catatan Jaringan
- Azure NSG dan UFW adalah dua lapis firewall terpisah. Port 80
  diizinkan di keduanya.
