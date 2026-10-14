# Surat

Cloud Computing — PTI 2802
Pertemuan 3 — Project Inception

## Author
Fenny — NIM 25832074005

## Problem
Petugas administrasi (tata usaha/sekretariat) pada sekolah, perusahaan,
dan instansi pemerintah kesulitan melacak surat masuk dan keluar karena
pencatatan tersebar dan tidak terpusat. Sistem ini akan menyediakan
pencatatan, pencarian, dan pelacakan status surat secara terpusat.

## Target Users
- Petugas administrasi surat (pengguna utama)
- Pimpinan/penerima disposisi
- Administrator sistem

## Features M03
- baseline aplikasi Flask (halaman utama, `/health`, `/api/info`)
- deployment pertama di VPS
- berjalan sebagai service systemd dan hidup kembali setelah reboot

## Architecture

```mermaid
flowchart LR
    U[User] --> C[Caddy]
    C --> G[Gunicorn]
    G --> F[Flask]
```

Detail ada di `docs/architecture.md`.

## Infrastructure
- VM Azure, Ubuntu Server 22.04.5 LTS
- 2 vCPU, 891 MiB RAM, 62 GB disk
- Caddy, Gunicorn, systemd, UFW

## Public Endpoint
`http://40.83.96.115/`

## Health Check
`GET /health`

## Deployment
Lihat `docs/deployment.md`.

## Documentation
- `docs/requirements.md`
- `docs/architecture.md`
- `docs/deployment.md`
- `docs/adr/0001-initial-architecture.md`
- `docs/evidence/m03/`

## Security
- SSH hanya dengan key, login root dan password dinonaktifkan
- UFW aktif (hanya port 22 dan 80)
- backend hanya listen di loopback (127.0.0.1:8000)
- tidak ada secret di repository

## Current Limitations
- HTTP saja (belum HTTPS)
- belum ada database
- belum ada container
- deployment masih manual

## Roadmap
M04 DNS/HTTPS, M05 Data, M06 Container, M07 IaC, M09 CI/CD
