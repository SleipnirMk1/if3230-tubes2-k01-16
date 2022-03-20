# if3230-tubes2-k01-16
* Ilyasa Salafi Putra Jamal (13519023)
* Haikal Lazuardi Fadil (13519027)
* Rayhan Alghifari Fauzta (13519039)

## Cara Kerja Program
Terdapat dua komponen yg memanfaatkan pemrosesan paralel CUDA.

Proses pertama adalah penghitungan konvolusi matriks. Perhitungan konvolusi menggunakan kombinasi thread parallel dan block parallel dengan jumlah thread dalam kernel sebanyak 128.

Proses kedua adalah sorting hasil selisih nilai maksimum dan minimum dari hasil konvolusi. Sorting menggunakan algoritma odd-even sort atau disebut juga brick sort. Algoritma ini bekerja dengan cara memilih elemen urutan genap (index ganjil) dan membandingkannya dengan elemen sebelumnya dan kemudian setelahnya. Ini dlakukan sebanyak jumlah elemen dibagi 2.

## Perbandingan Waktu Eksekusi Serial & Paralel
### Test Case 1
<img src="/screenshots/TC1.png" style="max-width: 120px">

### Test Case 2
<img src="/screenshots/TC2.png" style="max-width: 120px">

### Test Case 3
<img src="/screenshots/TC3.png" style="max-width: 120px">

### Test Case 4
<img src="/screenshots/TC4.png" style="max-width: 120px">

### Summary
| TC  | Paralel  | Serial   |
|--------------|----------|----------|
| TC1          | 0.138327 | 0.008936 |
| TC2          | 0.244463 | 0.769865 |
| TC3          | 0.393585 | 0.742717 |
| TC4          | 2.505191 | 9.789979 |

Penggunaan thread lebih cocok untuk dataset yang berukuran lebih besar. Selain itu, program paralel akan bekerja lebih efektif seiring dengan berkembangnya ukuran dataset. Sehingga sesuai dengan hasil percobaan di mana eksekusi program paralel lebih cepat dibandingkan program serial.

## Perbedaan Hasil Serial & Paralel
Hasil eksekusi program menunjukkan perbedaan hasil min, max, median, dan mean antara program serial dan paralel. Hal ini tergolong menyimpang dari kondisi umumnya yaitu hasil eksekusi serial dan paralel memberikan hasil yang sama dan hanya waktunya saja yang berbeda. Jika dianalisis penyebabnya, satu hal yang paling mungkin terjadi adalah kesalahan implementasi paralelisasi program. Proses penghitungan konvolusi matriks kemungkinan besar kurang sempurna dari segi pengalokasian thread ke matriks kernel atau output saat proses konvolusi.

## Analisis Hasil Eksekusi
Dari ketiga kasus yang diberikan sebagai berikut:

* Jumlah Matrix: 10000, Ukuran Kernel: 1x1, Ukuran Matrix: 1x1
* Jumlah Matrix: 1, Ukuran Kernel: 1x1, Ukuran Matrix: 100x100
* Jumlah Matrix: 1, Ukuran Kernel: 100x100, Ukuran Matrix: 100x100

Berdasarkan hipotesis kami, waktu eksekusi yang paling cepat akan dicapai oleh kasus kedua. Pada program kami, proses konvolusi akan disesuaikan dengan jumlah matriks inputnya. Karena hal ini, kasus pertama akan berjalan paling lama karena memiliki jumlah matriks paling banyak. Akan tersisa kasus kedua dan ketiga dengan jumlah matriks dan ukuran matriks yang sama. Melihat dari ukuran kernel, kasus kedua memiliki keunggulan karena kernel yang digunakan berukuran 1x1. Ukuran kernel yang kecil ini akan menghasilkan matriks konvolusi yang lebih besar sehingga proses perhitungan dilakukan oleh lebih banyak thread dalam satu waktu.
