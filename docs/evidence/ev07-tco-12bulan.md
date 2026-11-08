# EV-07 TCO 12 Bulan dan Budget Alert

Proyek: SuratKita (Sistem Pengelolaan Surat Masuk dan Keluar Berbasis Cloud)
Mahasiswa: Fenny Widiani, NIM 25832074005, Kelas 2B
Tanggal penyusunan: 2026-11-08
Catatan sanitasi: tidak memuat Subscription ID, ID billing account, email, password, atau key.

## 1. Kredit dan masa berlaku (portal Azure, Education Overview, 7 November 2026)

| Item | Nilai |
|---|---|
| Kredit Azure for Students | US$100 |
| Sisa kredit | US$89 |
| Kedaluwarsa | 18 September 2027 (315 hari lagi per 7-11-2026) |
| Biaya November 2026 sampai 7-11-2026 | US$2,09 (seluruh akun) |

Kredit adalah saldo terbatas, bukan tarif VM gratis permanen.

## 2. Tagihan aktual 1-7 November 2026 (Cost Management, Group by Resource)

| Resource | Biaya | Milik |
|---|---|---|
| fennyw-ip (IP publik) | US$0,74 | proyek SuratKita |
| fennyw_OsDisk (disk OS) | US$0,60 | proyek SuratKita |
| fennyw (VM, komputasi) | kurang dari US$0,01 | proyek SuratKita |
| pip-fenny-vnet-east... (IP publik) | US$0,74 | resource group lain (fenn_group) |
| fenny_disk1_bda9f28... | US$0,00 | resource group lain |
| **Total akun** | **US$2,09** | prakiraan November (portal): US$8,76 |

Resource group proyek (fenny_cc_ubuntu24) berjumlah US$1,35. Tagihan VM tercatat hampir nol pada periode ini; penyebabnya belum diverifikasi, sehingga harga bruto tetap dipakai pada TCO di bawah.

## 3. Burn-rate (ekstrapolasi, bukan tagihan sebulan penuh)

Dasar: biaya aktual 1-7 November 2026, dihitung sekitar 6,5 hari dan 30 hari per bulan.

| Cakupan | Perkiraan per bulan |
|---|---|
| Resource proyek (IP + disk + VM) | sekitar US$6,2 |
| Seluruh akun (termasuk fenn_group) | sekitar US$9,6 |

## 4. Harga bruto sebelum kredit (bila VM menyala 24/7)

| Komponen | Per bulan | Dasar |
|---|---|---|
| Komputasi VM Standard B2ats v2 | US$9,56 | US$0,0131/jam x 730 jam; harga di portal saat pembuatan VM, 15-10-2026 |
| Disk OS 30 GiB (Standard SSD LRS) | sekitar US$2,8 | ekstrapolasi dari US$0,60 (1-7 Nov 2026) |
| IP publik IPv4 | sekitar US$3,4 | ekstrapolasi dari US$0,74 (1-7 Nov 2026) |
| Data keluar (egress) | US$0 | 100 GB pertama per bulan gratis; pemakaian teramati kurang dari US$0,01 |
| Backup (Azure Blob Storage, LRS) | US$0 sampai sekitar US$0,24 | jatah gratis 5 GB; di atasnya perkiraan US$0,024/GB (sumber pembanding pihak ketiga, perlu diverifikasi di Azure Pricing Calculator); contoh 10 GB |
| DNS dan domain | belum ditetapkan | FQDN belum ada (ev02); dicatat setelah domain ditentukan |
| API/layanan pihak ketiga | tidak dipakai | |
| **Total bruto** | **sekitar US$16,0** | **sekitar Rp290.000** pada kurs Rp18.130/US$ (JISDOR Bank Indonesia, 6-11-2026) |

## 5. TCO 12 bulan

| Skenario | USD | Rupiah (kurs Rp18.130) |
|---|---|---|
| Bruto 12 bulan (16,0 x 12) | sekitar US$192 | sekitar Rp3,48 juta |
| Kontingensi 20% (asumsi) | sekitar US$38 | sekitar Rp0,70 juta |
| **Total dengan kontingensi** | **sekitar US$230** | **sekitar Rp4,18 juta** |

Catatan konsistensi: angka US$190 per tahun pada Bagian 4.3 tidak memasukkan Blob Storage. Biaya kas (dibayar sendiri) adalah US$0 selama kredit masih ada; biaya nonkas adalah kredit yang terpakai.

## 6. Skenario kredit

| Skenario | Perkiraan | Hasil |
|---|---|---|
| A. Seluruh akun berjalan seperti sekarang (sekitar US$9,6/bulan) | US$89 : US$9,6 = sekitar 9 bulan | Kredit habis sekitar Agustus 2027, sebelum kedaluwarsa 18-9-2027 |
| B. Hanya resource proyek (sekitar US$6,2/bulan) | 315 hari = sekitar 10,4 bulan x US$6,2 = sekitar US$64 | Kredit sampai kedaluwarsa, sisa sekitar US$25 |
| C. Sesudah kredit habis atau kedaluwarsa | sekitar US$16/bulan bruto | Perlu keputusan stop atau upgrade (bagian 8) |

Skenario ini perkiraan kasar dari ekstrapolasi 7 hari dan akan diperbarui dengan tagihan sebulan penuh.

## 7. Budget alert (portal Azure, Cost Management, Budgets, 8 November 2026)

| Item | Nilai |
|---|---|
| Nama | budget-suratkita |
| Jumlah | US$10 per bulan (reset bulanan) |
| Berlaku | 1 November 2026 sampai 31 Oktober 2028 |
| Cakupan | billing account (seluruh akun, termasuk resource group lain) |
| Alert | Actual cost 50% (US$5), 80% (US$8), 100% (US$10); Forecasted cost 100% (US$10) |
| Penerima | email pemilik akun (tersanitasi) |
| Status | Dibuat; Azure menyatakan evaluasi dimulai beberapa jam setelah pembuatan |

Dasar jumlah US$10: prakiraan maksimal bulanan di form budget sekitar US$9 dan burn-rate seluruh akun sekitar US$9-10 per bulan.

## 8. Keputusan stop atau upgrade (usulan)

| Pemicu | Tindakan |
|---|---|
| Alert Actual 80% (US$8) | Tinjau tagihan per resource di Cost analysis |
| Alert Actual atau Forecasted 100% (US$10) | Hapus resource yang tidak dipakai (misalnya IP publik atau disk di resource group lain); bila tidak cukup, hentikan proyek |
| Sisa kredit di bawah US$15 | Backup data ke penyimpanan lain, lalu hentikan VM dan hapus resource proyek |
| Kredit habis atau kedaluwarsa (18-9-2027) | Putuskan stop, atau upgrade ke akun berbayar dengan anggaran sekitar US$16 per bulan |

Catatan: tagihan VM saat ini hampir nol, sehingga mematikan VM belum tentu menghemat; yang menghemat adalah menghapus IP publik dan disk. Hal ini perlu diverifikasi.

## 9. Bukti terlampir (screenshot tersanitasi, 7-8 November 2026)

- Halaman Education Overview (kredit, sisa, kedaluwarsa)
- Cost analysis per resource (1-7 November 2026)
- Daftar Budgets dan rincian alert budget-suratkita

## 10. Isu tersisa

- Biaya domain dan DNS menunggu keputusan FQDN (ev02).
- Tarif Blob Storage perlu diverifikasi di Azure Pricing Calculator (East Asia, LRS, Hot) dan dicatat tanggalnya.
- Burn-rate dan skenario kredit diperbarui dengan tagihan sebulan penuh (akhir November 2026).
- Verifikasi apakah tagihan VM hampir nol karena jatah gratis, dan sampai kapan berlaku.