# ADR-0001: Initial VPS Deployment Architecture

## Status
Accepted

## Context
Proyek perlu dideploy pertama kali ke VPS publik. Spesifikasi lingkungan
yang sebenarnya (diukur dengan nproc, free -h, df -h):

- VM cloud (Azure), Ubuntu Server 24.04.5 LTS, Python 3.12.3
- 2 vCPU, 836 MiB RAM, disk 29 GB, tanpa swap
- IPv4 publik, akses administrasi lewat SSH

Catatan: versi OS sesuai modul (Ubuntu 24.04, Python 3.12). Spesifikasi
VM berbeda dari asumsi modul (1 vCPU, 1 GB RAM, disk 20 GB): VM memiliki
2 vCPU, RAM sedikit lebih kecil, dan disk lebih besar. Perbedaan ini
tidak mengubah keputusan arsitektur karena RAM tetap menjadi batas
utama, tetapi dicatat agar dokumentasi jujur.

## Decision
- Flask sebagai framework aplikasi
- Gunicorn dengan 1 worker dan 2 thread, bind ke 127.0.0.1:8000
- systemd untuk mengelola proses aplikasi
- Caddy sebagai reverse proxy publik di port 80
- UFW sebagai firewall host (hanya port 22 dan 80)
- GitHub sebagai repository, deploy lewat git pull di VPS

## Alternatives
1. Node.js + PM2
2. NGINX + Gunicorn
3. Docker
4. PHP-FPM

## Rationale
- Flask + Gunicorn ringan dan cocok untuk VM dengan RAM sekitar 1 GB.
- Jumlah worker dibatasi oleh RAM, bukan oleh jumlah CPU, sehingga
  1 worker dengan 2 thread tetap dipilih walaupun tersedia 2 vCPU.
  Ini menyisakan headroom untuk SSH, systemd, dan Caddy.
- Gunicorn hanya listen di loopback sehingga tidak terekspos langsung;
  satu-satunya pintu masuk publik adalah Caddy.
- systemd memastikan aplikasi otomatis hidup kembali setelah crash atau
  reboot dan lognya terkumpul di journald.
- Caddy konfigurasinya lebih sederhana daripada NGINX dan siap
  dikembangkan ke HTTPS otomatis pada M04.
- Node.js + PM2 dan PHP-FPM ditolak karena tidak sejalan dengan stack
  Python yang dipakai proyek; Docker ditolak untuk M03 karena
  containerization menjadi materi M06.

## Consequences
### Positive
- Footprint kecil dan mudah dipahami.
- Attack surface kecil: hanya port 22 dan 80 yang terbuka.
- Deployment dapat direproduksi dari repository.

### Negative
- Hanya HTTP (belum HTTPS) sampai M04.
- Satu VPS tanpa redundansi (single point of failure).
- Deployment masih manual (git pull dan restart service).

## Review Trigger
Review pada M06/M07, atau jika beban melebihi kapasitas
2 vCPU / 836 MiB RAM.
