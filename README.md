# if3230-tubes2-k01-16
* Ilyasa Salafi Putra Jamal (13519023)
* Haikal Lazuardi Fadil (13519027)
* Rayhan Alghifari Fauzta (13519039)

## Cara Kerja Program

## Perbandingan Waktu Eksekusi Serial & Paralel
### Test Case 1
Serial
<img src="/screenshots/TC1-serial.png" style="max-width: 120px">

Paralel
<img src="/screenshots/TC1.png" style="max-width: 120px">

### Test Case 2
Serial
<img src="/screenshots/TC2-serial.png" style="max-width: 120px">

Paralel
<img src="/screenshots/TC2.png" style="max-width: 120px">

### Test Case 3
Serial
<img src="/screenshots/TC3-serial.png" style="max-width: 120px">

Paralel
<img src="/screenshots/TC3.png" style="max-width: 120px">

### Test Case 4
Serial
<img src="/screenshots/TC4-serial.png" style="max-width: 120px">

Paralel
<img src="/screenshots/TC4.png" style="max-width: 120px">

### Summary
| TC \| Method | Serial   | Paralel  |
|--------------|----------|----------|
| TC1          | 0.009796 | 0.130920 |
| TC2          | 0.740646 | 0.265493 |
| TC3          | 0.736021 | 0.405243 |
| TC4          | 9.756246 | 2.564888 |

Penggunaan thread lebih cocok untuk dataset yang berukuran lebih besar. Selain itu, program paralel akan bekerja lebih efektif seiring dengan berkembangnya ukuran dataset. Sehingga sesuai dengan hasil percobaan di mana eksekusi program paralel lebih cepat dibandingkan program serial.

## Perbedaan Hasil Serial & Paralel
Terdapat perbedaan pada hasil penghitungan program serial dan paralel. Kami menduga hal ini dapat disebabkan oleh kesalahan dalam paralelisasi sehingga proses dijalankan dengan jumlah yang tidak sesuai dengan seharusnya. Hal tersebut bisa menyebabkan terjadinya penghitungan yang tidak seharusnya ada, atau sebaliknya. Ini dapat memengaruhi hasil, sehingga menyebabkan perbedaan hasil.

## Analisis Hasil Eksekusi
