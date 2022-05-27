# Hasil sniff API APK Sidompul XL
Hasil sniff API dari APK Sidompul XL. Cara menggunakan:
1. Clone repository ini: `git clone https://github.com/hillz2/sidompul_api.git`
2. Change direcotry: `cd sidompul_api`
3. Edit variable "login_email" di script sidompul.sh dengan email yang sudah di daftarkan di aplikasi Sidompul XL
4. Set executable: `chmod +x sidompul.sh`
5. Jika email yang dipakai sudah login di aplikasi Sidompul smartphone, logout dulu, emailnya nggak bisa untuk multi login
6. Jalankan script: `./sidompul.sh [Nomer XL]`

Contoh Output:
```
[manjaro@manjaro tmp]$ ./sidompul.sh 08xxxxxxxx
Login xxxxxx@gmail.com
OTP Sent...       
Insert OTP: 049878
OTP Verified...
Access Token: xxxxxxxx-xxxxx-xxxxx-xxxxx-xxxxxxxxx
Cek Kuota 628xxxxxxxx...

NAME: BONUS KUOTA HARIAN
EXPDATE: 2025-01-17
TYPE: DATA
BNAME: FACEBOOK WHATSAPP LINE
QUOTA: 100 MB
REMAINING: 96 MB
TYPE: DATA
BNAME: MEETING DAN BELAJAR ONLINE
QUOTA: 700 MB
REMAINING: 0
TYPE: DATA
BNAME: GRAB DAN GOJEK
QUOTA: 100 MB
REMAINING: 0
TYPE: DATA
BNAME: GOOGLE MAPS
QUOTA: 100 MB
REMAINING: 94 MB

NAME: FREE INTERNET 1GB, 30HR
EXPDATE: 2022-06-23
TYPE: DATA
BNAME: 24JAM DI 2G3G4G
QUOTA: 1 GB
REMAINING: 0

NAME: BONUS PAKET AKRAB
EXPDATE: 2022-05-30
TYPE: SMS
BNAME: SMS (KE XL)
QUOTA: 1000
REMAINING: 1000
TYPE: VOICE
BNAME: NELP (KE XL)
QUOTA: 43200 MINUTES
REMAINING: 43200 MINUTES
TYPE: DATA
BNAME: KUOTA NASIONAL
QUOTA: 1 GB
REMAINING: 0
TYPE: DATA
BNAME: KUOTA LOKAL 2
QUOTA: 1 GB
REMAINING: 0

NAME: PAKET AKRAB S, 30HR
EXPDATE: 2022-05-30
TYPE: DATA
BNAME: UNLIMITED
QUOTA: 25 GB
REMAINING: 24.46 GB
TYPE: DATA
BNAME: 24JAM DI SEMUA JARINGAN
QUOTA: 20 GB
REMAINING: 2.07 GB
```

Perbedaan script ini dengan yang versi sidompul android yaitu discript ini kita bisa mengetahui jumlah total kuota unlimited di paket yang sudah terdaftar, contohnya kuota unlimited paket akrab XL

Contact: [Facebook](https://fb.me/galihpa)
