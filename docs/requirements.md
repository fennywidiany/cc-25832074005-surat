# Requirements

## Problem Statement
Petugas administrasi (tata usaha/sekretariat) pada organisasi seperti
sekolah, perusahaan, dan instansi pemerintah mengalami kesulitan
melacak surat masuk dan keluar karena pencatatan tersebar dan tidak
terpusat.

Sistem akan menyediakan pencatatan, pencarian, dan pelacakan status
surat secara terpusat sehingga setiap surat dapat ditelusuri dan
tindak lanjutnya tidak terlewat.

## Target Users
- Petugas administrasi surat (pengguna utama)
- Pimpinan/penerima disposisi (pengguna sekunder)
- Administrator sistem

## User Needs
- Sebagai petugas administrasi, saya ingin mencatat surat masuk dan
  keluar, sehingga arsip surat tersimpan terpusat.
- Sebagai petugas administrasi, saya ingin mencari surat berdasarkan
  nomor, pengirim, atau tanggal, sehingga surat mudah ditemukan.
- Sebagai pimpinan, saya ingin melihat surat yang belum ditindaklanjuti,
  sehingga tidak ada surat yang terlewat.

## Functional Requirements

### Diimplementasikan pada M03
- FR-01 Sistem menampilkan halaman utama.
- FR-02 Sistem menyediakan endpoint GET /health yang mengembalikan
  HTTP 200 dan JSON dengan status "ok".
- FR-03 Sistem menyediakan endpoint GET /api/info yang menampilkan
  metadata aplikasi.

### Direncanakan (setelah M03)
- FR-04 Sistem mencatat surat masuk (nomor, pengirim, tanggal, perihal).
- FR-05 Sistem mencatat surat keluar (nomor, tujuan, tanggal, perihal).
- FR-06 Sistem mencari surat berdasarkan nomor, pihak terkait, atau tanggal.
- FR-07 Sistem menyimpan status surat (diterima, diproses, selesai).

## Non-Functional Requirements
- NFR-01 Backend hanya listen pada loopback (127.0.0.1:8000).
- NFR-02 Aplikasi dikelola oleh systemd.
- NFR-03 Request publik masuk melalui reverse proxy (Caddy).
- NFR-04 Secret tidak disimpan pada Git repository.
- NFR-05 Health endpoint mengembalikan HTTP 200 saat sehat.
- NFR-06 Deployment dapat direproduksi dari repository.
- NFR-07 Arsitektur sesuai kapasitas VM (2 vCPU, 836 MiB RAM).

## Scope
### In Scope M03
- repository, requirements, architecture, ADR
- baseline aplikasi Flask
- SSH hardening dasar, UFW
- Gunicorn, systemd, Caddy
- deployment HTTP publik

### Out of Scope M03
- database production
- Docker
- Infrastructure as Code
- CI/CD
- TLS/domain production
- aplikasi client desktop

## Constraints
- 2 vCPU
- 836 MiB RAM
- 29 GB disk
- Ubuntu Server 24.04.5 LTS (sesuai modul, lihat ADR-0001)
- public IPv4

## Acceptance Criteria M03
- [x] first deployment dapat diakses dari internet
- [x] health endpoint mengembalikan HTTP 200
- [x] aplikasi berjalan sebagai service systemd
- [x] aplikasi hidup kembali setelah reboot
- [x] backend hanya listen pada loopback
