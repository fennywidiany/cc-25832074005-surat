# EV-05 Backup off-site

Tanggal pengujian: 9 November 2026
Data: dummy (tidak ada surat sungguhan)

## 1. Lokasi dan retensi (tanpa secret)
- Akun penyimpanan: stsuratkita25832074005
- Container: backup-suratkita (privat, akses anonim nonaktif)
- Region: East Asia; redundansi: LRS
- Enkripsi: age di VPS sebelum unggah; kunci privat di luar VPS
- SAS token: izin acwl (tanpa baca dan hapus), berlaku sampai 1 Maret 2027, diganti sebelum 28 Februari 2027
- Lifecycle: daily/ dihapus setelah 7 hari, weekly/ setelah 28 hari (img/lifecycle.png)

## 2. Jadwal (hasil cat /etc/cron.d/suratkita-backup)
0 2 * * * root /usr/local/bin/suratkita-backup.sh >> /var/log/suratkita-backup.log 2>&1

## 3. Skrip
Lihat suratkita-backup.sh di folder ini. Skrip hanya membaca variabel dari /etc/suratkita-backup.env, tidak ada token di dalamnya.

## 4. Tes enkripsi dan dekripsi (laptop, 9 November 2026)
Berkas uji dienkripsi dengan age dan dibuka dengan kunci privat.
SHA-256 berkas asli dan hasil dekripsi sama:
0A74E289576737E60ED98BC5B29F489F9579491EF50408FD1B734376D22D5A09

## 5. Backup uji (9 November 2026)
2026-11-09T19:22:53+07:00 OK suratkita-20261109T122253Z.tar.gz.age sha256=3dfef96fb092b6ab7ac52142d3714e1a07ee4fd81e8f3a05a63527e490e4eaab size=763
Berkas terlihat di container daily/ (img/container-daily.png).

## 6. Uji izin SAS (9 November 2026, berkas dummy)
list: 200 (harapan 200)
baca: 403 (harapan 403)
hapus: 403 (harapan 403)
tanpa token: 409 (harapan 404/409/403)

## 7. Log backup terjadwal berturut-turut
(diisi setelah cron berjalan beberapa hari)

## 8. Status
- Skrip, enkripsi, unggah: lulus (9 Nov 2026)
- Izin token terbatas: lulus (9 Nov 2026)
- Backup terjadwal berturut-turut: belum
- Dekripsi dan restore: belum (ev06)

## 9. Catatan
- Backup percobaan awal berformat .enc (data dummy) sudah dihapus dari container pada 9 November 2026 dan tidak dipakai sebagai bukti.
- Data uji berasal dari folder /srv/cc-m03-uji. Setelah M05, skrip diarahkan ke database dan lampiran aplikasi yang sebenarnya, dan perubahan dicatat di sini.
