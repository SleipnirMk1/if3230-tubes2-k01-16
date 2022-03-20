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
| TC \| Method | Paralel  | Serial   |
|--------------|----------|----------|
| TC1          | 0.138327 | 0.008936 |
| TC2          | 0.244463 | 0.769865 |
| TC3          | 0.393585 | 0.742717 |
| TC4          | 2.505191 | 9.789979 |

Penggunaan thread lebih cocok untuk dataset yang berukuran lebih besar. Selain itu, program paralel akan bekerja lebih efektif seiring dengan berkembangnya ukuran dataset. Sehingga sesuai dengan hasil percobaan di mana eksekusi program paralel lebih cepat dibandingkan program serial.

## Perbedaan Hasil Serial & Paralel
Terdapat perbedaan pada hasil penghitungan program serial dan paralel. Kami menduga hal ini dapat disebabkan oleh kesalahan dalam paralelisasi sehingga proses dijalankan dengan jumlah yang tidak sesuai dengan seharusnya. Hal tersebut bisa menyebabkan terjadinya penghitungan yang tidak seharusnya ada, atau sebaliknya. Ini dapat memengaruhi hasil, sehingga menyebabkan perbedaan hasil.

## Analisis Hasil Eksekusi
Program paralel dilakukan dengan memproses matriks, sehingga waktu eksekusi ditentukan oleh jumlah matriks.