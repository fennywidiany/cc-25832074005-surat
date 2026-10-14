# Catatan Praktikum M03

## Lingkungan Aktual
- VM Azure, Ubuntu Server 22.04.5 LTS, Python 3.10.12
- 2 vCPU, 891 MiB RAM, 62 GB disk, tanpa swap
- Modul menetapkan Ubuntu 24.04, 1 vCPU, disk 20 GB. Perbedaan dicatat
  di ADR-0001.

## Temuan dan Troubleshooting

### 1. Konfigurasi SSH di cloud-init menimpa hardening
- Gejala: `sshd_config.d/50-cloud-init.conf` berisi
  `PasswordAuthentication yes`, sedangkan `60-cloudimg-settings.conf`
  berisi `no`.
- Penyebab: OpenSSH memakai nilai pertama yang dibaca, urut menurut nama
  file. File `99-pti2802.conf` (nama di modul) dibaca paling akhir
  sehingga kalah.
- Solusi: file hardening dinamai `01-pti2802.conf` agar dibaca paling
  awal. Diverifikasi dengan `sudo sshd -T` (passwordauthentication no).
- Bukti: login `fenny` ditolak dengan `Permission denied (publickey)`.

### 2. Log Gunicorn: Control server error
- Gejala: `[ERROR] Control server error: [Errno 13] Permission denied:
  '/home/cloudstudent'` pada log Gunicorn 26.2.0.
- Penyebab: `ProtectHome=true` pada systemd membatasi akses ke /home,
  sehingga fitur control socket opsional Gunicorn tidak dapat dibuat.
- Dampak: tidak ada. Aplikasi tetap melayani request (/health = 200).
- Keputusan: dibiarkan karena fitur tersebut tidak dipakai dan proteksi
  ProtectHome dipertahankan.

### 3. Gunicorn manual bertahan setelah sesi SSH putus
- Gejala: proses Gunicorn yang dijalankan manual dengan `&` masih
  listen di 127.0.0.1:8000 setelah sesi SSH tertutup.
- Pelajaran: proses background tidak otomatis mati saat sesi putus.
  Proses dimatikan manual sebelum service systemd dibuat agar port 8000
  tidak bentrok.

## Verifikasi Reboot
- Setelah `sudo reboot`: UFW active, Caddy active (running),
  `cc-m03` enabled dan active, /health = ok.
- Tes eksternal dari laptop ke IP publik berhasil setelah reboot.

## Catatan Jaringan
- Azure NSG dan UFW adalah dua lapis firewall terpisah. Port 80
  diizinkan di keduanya.
