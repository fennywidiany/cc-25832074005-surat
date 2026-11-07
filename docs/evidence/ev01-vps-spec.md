# EV-01 Spesifikasi VPS

Proyek: SuratKita (Sistem Pengelolaan Surat Masuk dan Keluar Berbasis Cloud)
Mahasiswa: Fenny Widiani, NIM 25832074005, Kelas 2B
Tanggal pengamatan: 2026-11-07 09:35 UTC
Metode: Azure Portal, VM `fennyw`, menu Operations, Run command, RunShellScript
Catatan sanitasi: tidak memuat Subscription ID, password, key, token, atau data pribadi.

## 1. Metadata VM (portal Azure, halaman Overview, 7 November 2026)

| Item | Nilai |
|---|---|
| Nama resource VM | fennyw |
| Computer name | cc-m03-25832074005 |
| Resource group | fenny_cc_ubuntu24 |
| Penyedia / paket | Microsoft Azure, langganan Azure for Students |
| Ukuran (SKU) | Standard B2ats v2 (2 vCPU, 1 GiB RAM) |
| Lokasi | East Asia, Availability Zone 1 |
| Status | Running |
| Dibuat | 2026-10-15 10:37 UTC |
| Image | Canonical ubuntu-24_04-lts (server), VM generation V2, x64 |
| Security type | Trusted launch (Secure boot dan vTPM aktif) |
| IP publik (IPv4) | 20.2.137.217 |
| IP publik (IPv6) | Tidak ada |
| IP privat | 172.16.0.4 |
| VNet / subnet | vnet-eastasia-1 / snet-eastasia-1 |
| DNS name | Belum dikonfigurasi |
| Data disk | 0 (hanya OS disk) |
| Auto-shutdown | Tidak aktif |

## 2. Hasil perintah di VM

### os-release

```text
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.5 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```

### uname -a

```text
Linux cc-m03-25832074005 7.0.0-1017-azure #17~24.04.1-Ubuntu SMP PREEMPT Thu Sep 24 18:46:57 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```

### nproc

```text
2
```

### free -h

```text
               total        used        free      shared  buff/cache   available
Mem:           836Mi       282Mi       103Mi       3.9Mi       476Mi       554Mi
Swap:             0B          0B          0B
```

### lsblk

```text
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda       8:0    0   30G  0 disk 
├─sda1    8:1    0   29G  0 part /
├─sda14   8:14   0    4M  0 part 
├─sda15   8:15   0  106M  0 part /boot/efi
└─sda16 259:0    0  913M  0 part /boot
```

### df -h /

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  3.0G   26G  11% /
```

### ss -lnt

```text
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*          
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*          
LISTEN 0      4096       127.0.0.1:2019      0.0.0.0:*          
LISTEN 0      4096         0.0.0.0:22        0.0.0.0:*          
LISTEN 0      2048       127.0.0.1:8000      0.0.0.0:*          
LISTEN 0      4096               *:80              *:*          
LISTEN 0      4096            [::]:22           [::]:*          
```

### ufw status verbose

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
80/tcp                     ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             
80/tcp (v6)                ALLOW IN    Anywhere (v6)             
```

## 3. Ringkasan dan status pemeriksaan

| Pemeriksaan | Hasil terukur | Yang diharapkan | Status |
|---|---|---|---|
| Sistem operasi | Ubuntu 24.04.5 LTS | Ubuntu Server 24.04 LTS | Lulus |
| CPU | 2 (nproc) | 2 vCPU sesuai SKU | Lulus |
| RAM | 836 MiB terbaca OS (SKU 1 GiB) | Mendekati 1 GiB | Lulus |
| Swap | 0 B | Tidak ada | Dicatat sebagai keterbatasan |
| Disk | 30G disk, partisi root 29G, terpakai 3,0G (11%) | 30 GiB | Lulus |
| Firewall UFW | Aktif, default tolak masuk | Aktif | Lulus |
| Port terbuka | 22/tcp dan 80/tcp (IPv4 dan IPv6) | 22 dan 80; 443 menyusul pada M04 | Lulus |
| Port 2019 dan 8000 | Hanya mendengarkan di 127.0.0.1 | Tidak terbuka ke internet | Lulus |
| DNS name / HTTPS | Belum ada | Menyusul pada M04 (lihat ev02) | Belum dikerjakan |

## 4. Catatan dan isu tersisa

- Nilai di atas adalah hasil pengamatan pada tanggal tertulis, bukan hasil uji beban atau uji keamanan.
- Port 22 (SSH) terbuka untuk semua alamat (`Anywhere`). Dicatat sebagai risiko; rencana pembatasan akses dibahas pada bagian keamanan.
- RAM 1 GiB tanpa swap adalah batas kapasitas yang perlu diukur pada uji beban (ev08).
- Proses yang menggunakan port 2019 dan 8000 tidak diidentifikasi pada output ini.

## 5. Sumber dan ketelusuran

- Berkas ini: `docs/evidence/ev01-vps-spec.md`
- Commit: lihat riwayat commit berkas ini di repository
- Screenshot portal Azure Overview VM tersanitasi: 7 November 2026