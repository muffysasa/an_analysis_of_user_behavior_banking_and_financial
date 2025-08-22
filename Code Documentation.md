# Analisis dan Perilaku Nasabah Pada Sektor Financial dan Banking 
_Makrufiah Sakatri_

![Image](./img/Businessman%20pushing%20credit%20score%20speedometer%20from%20poor%20to%20good.jpg)
*all source pictures here from [Freepik](https://www.freepik.com/)*

Dashboard Visualisasi [![](https://img.icons8.com/?size=30&id=SruJhzn0nnLl&format=png&color=000000)](https://lookerstudio.google.com/reporting/a71b18bc-15f2-4d31-8a1e-612864d6187b)
## 1. Domain Project
Bank adalah lembaga keuangan yang menyediakan layanan penyimpanan uang, pemberian pinjaman, serta penerbitan tagihan serta pencatatan transaksi nasabah.
Dalam aktivitasnya, setiap nasabah melakukan berbagai transaksi (penarikan, transfer, pembayaran, pembelian, kredit, dll) yang semuanya tercatat dalam data. Berdasarkan CRISP-DM (Cross Industry Standard Process for Data Mining) merupakan metodologi standar yang banyak digunakan untuk mengelola proyek analisis data, termasuk dalam konteks Big Data perbankan. Dengan memanfaatkan data transaksi dan nasabah, bank dapat memahami perilaku pengguna untuk tujuan berbagai tujuan bisnis dan operasional.

## 2. Business Understanding
- Problem Statement

Dalam dunia perbankan dan lembaga keuangan, analisis perilaku nasabah merupakan langkah penting untuk memahami kebutuhan bisnis sekaligus kebutuhan nasabah. Salah satu contohnya adalah pengelolaan credit score yang berfungsi sebagai langkah antisipatif dalam strategi bank agar nasabah tidak mengalami gagal bayar. Oleh karena itu, diperlukan analisis perilaku nasabah yang didasarkan pada data transaksi dan catatan yang tersimpan di bank.
Berdasarkan data yang didapatkan meliputi demografi nasabah, informasi kartu nasabah serta aktivitas transaksi nasabah dapat di tujukan untuk tujuan sebagai berikut

- Goals nasabah dan perilaku penggunaan
1. Berapa jumlah nasabah yang terdaftar berdasarkan umur dan presentase para nasabah secara skala credit score?
2. Bagaimana perilaku para nasabah terhadap awareness keamanan data bank dengan penggantian password kartu bank?
3. Bagaimana perilaku para nasabah terhadap kemudahan produk transaksional bank terhadap aktivitas transaksi para nasabah?


## 3. Data Understanding
Data publik bersumber link   [![](https://img.icons8.com/?size=20&id=12312&format=png&color=000000)](https://drive.google.com/drive/folders/14U87BRaPXvv-l9E7dysGqY0VjVv4lxKP)
1. Data users_data
 id→  kode unik representasi nasabah
 current_age→  umur nasabah
 retirement_age→ usia pensiun nasabah
 birth_year→ tahun kelahiran nasabah  
 birth_month→ bulan kelahiran nasabah
 gender→  jenis kelamin nasabah
 address→  alamat nasabah
 latitude→  koordinat lat alamat nasabah
 longitude→ koordinat long alamat nasabah
 per_capita_income→ penghasilan perkapita sesuai kiteria nasabah
 yearly_income→ enghasilan pertahun
 total_debt→ umlah tagihan hutang
 credit_score→ kor kredit, menunjukan skala skor kredit nasabah dari lembaga penilaian kuangan  
 num_credit_cards→ jumlah kartu kredit aktif yang benar-benar sedang digunakan oleh nasabah

2. Data cards_data
id → Primary key unik tiap baris data.
client_id → ID unik untuk nasabah/pemilik kartu.
card_brand → Merek kartu (misal: Visa, MasterCard, Amex).
card_type → Jenis kartu (misal: Debit, Credit, Prepaid).
card_number → Nomor kartu (biasanya 16 digit).
expires → Tanggal kadaluarsa kartu (format MM/YY).
cvv → Kode keamanan (3 atau 4 digit di belakang kartu).
has_chip → Apakah kartu punya chip (Yes/No atau 1/0).
num_cards_issued → Jumlah kartu yang pernah diterbitkan untuk nasabah ini.
credit_limit → Limit kredit maksimal yang diberikan.
acct_open_date → Tanggal pembukaan akun / kartu pertama kali aktif.
year_pin_last_changed → Tahun terakhir nasabah mengganti PIN.
card_on_dark_web → Indikator apakah kartu ditemukan di “dark web” (misal: 1 = iya, 0 = tidak)

3. Data transaksional_data --> akan menggunakan range date 3 tahun terakhir 2019 s/d 2017
id → Primary key unik untuk tiap transaksi.
datetime → Waktu transaksi terjadi (tanggal & jam).
client_id → ID nasabah/pemilik kartu.
card_id → ID kartu yang digunakan (relasi ke tabel kartu).
amount → Nominal transaksi (misalnya dalam USD).
use_chip → Jenis chip kartu transaksi dilakukan dengan chip (
merchant_id → ID unik merchant (toko / penyedia layanan).
merchant_city → Kota tempat merchant berada.
merchant_state → Negara bagian / provinsi merchant.
zip → Kode pos merchant.
mcc → Merchant Category Code (kode industri merchant, misalnya restoran, retail, travel).
errors → Indikator adanya error saat transaksi (misalnya gagal otorisasi, declined, dsb).



## 4. Data Preparation
##### 4.1. Membaca data --> menggunakan Google Collab
_4.1.1 Mengambil data dari G-Drive_
```
import pandas as pd
from google.colab import drive
drive.mount('/content/drive')
```
_4.1.2 Membuat variabel data_
```
trans = pd.read_csv('/content/drive/MyDrive/DataTest1/dataset/transactions_data.csv')
cards = pd.read_csv('/content/drive/MyDrive/DataTest1/dataset/cards_data.csv')
users = pd.read_csv('/content/drive/MyDrive/DataTest1/dataset/users_data.csv')
```

_4.1.3 Melihat informasi data_
```
trans.info(show_counts=True)
cards.info()
users.info()
```

1. Data trans = 13305915 rows × 13 columns | terdapat nilai Null
2. Data cards = 6146 rows × 13 columns | tidak terdapat nilai Null
3. Data user = 2000 rows × 14 columns | tidak terdapat nilai Null

Pada data transaction_data menggunakan range data 2017-2019, Preparation Data akan menggunakan Python Google Collab untuk melakukan preparation data. Berikut langkah-langkah Preparation Data

_1.Konversi kolom datetime %Y-%m-%d %H:%M:%S"menjadi datetime[ns] dan split menjadi tanggal %Y-%m-%d_
```
from datetime import datetime
trans = trans.rename(columns={'date': 'datetime'}) ## rename nama kolom
trans['datetime'] = pd.to_datetime(trans['datetime'], format="%Y-%m-%d %H:%M:%S")
```
_2.Memfilter data berdasarkan kolom 'date' 2018-2019_
```
start_date = "2018-10-31"
end_date   = "2019-10-31"
trans_range = trans.loc[
    (trans['date'] >= start_date) & (trans['date'] <= end_date)
]
```
_3.Drop kolom data transaksi yang tidak digunakan_
```
trans_range_drop = trans_range.drop(columns=[ "datetime", "merchant_city", "merchant_state", "zip",
    "mcc",
], errors="ignore")
```
_4.Mengisi nilai null dengan string "No Error"_
```
trans_range_drop['errors']=trans_range_drop['errors'].fillna("No Error")
```
_5.Mendownload data transaksi dengan range 2018-2019_
```
trans_range_drop .to_csv('transaction2018-2019.csv', index=False)
```


##### 4.2. Membaca data --> menggunakan Microsoft SQL Server
###### 4.2.1. Data user
_1. Memilih kolom yang dibutuhkan_
```
select id, current_age, credit_score from DataTest1.dbo.users_data
```
_2. Melihat data dan membuat kategori skala kredit skor sesuai FICO_
credit scoring FICO yang dikembangkan oleh Fair Isaac Corporation, dengan rincian sebagai berikut:

- Nilai 300-579 dalam credit score adalah tergolong ke kategori buruk.
- Nilai 580-669 dalam credit score adalah tergolong ke kategori fair.
- Nilai 670-739 dalam credit score adalah tergolong ke kategori baik.
- Nilai 740-799 dalam credit score adalah tergolong ke kategori sangat bagus.
- Nilai 800-850 dalam credit score adalah tergolong ke kategori luar biasa.
Di metode scoring FICO, skor kredit yang baik adalah yang berada di atas 670.

sumber infromasi https://www.ocbc.id/id/article/2023/01/19/credit-score-adalah
```
SELECT id, current_age, credit_score,
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '300-579_Bad'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580-669_Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670-739_Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN '740-799_VeryGood'
        WHEN credit_score BETWEEN 800 AND 850 THEN '800-850_Excellent'   
    END AS credit_risk_score
FROM dbo.users_data
```
_3. Melihat distribusi nasabah berdasarkan umur_
```
SELECT 
    current_age,
    COUNT(*) AS total_user
FROM DataTest1.dbo.users_data
GROUP BY current_age
ORDER BY current_age
```
_4. Melihat distribusi nasabah berdasarkan skor kredit_
```
SELECT 
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '300-579_Bad'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580-669_Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670-739_Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN '740-799_VeryGood'
        WHEN credit_score BETWEEN 800 AND 850 THEN '800-850_Excellent' 
    END AS credit_risk_score,
    COUNT(*) AS total
FROM DataTest1.dbo.users_data
GROUP BY
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '300-579_Bad'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580-669_Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670-739_Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN '740-799_VeryGood'
        WHEN credit_score BETWEEN 800 AND 850 THEN '800-850_Excellent' 
    END
ORDER BY credit_risk_score;
```
_5. Melihat nasabah yang memiliki kredit skor buruk_
```SELECT 
    id, current_age,
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '300-579_Bad'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580-669_Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670-739_Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN '740-799_VeryGood'
        WHEN credit_score BETWEEN 800 AND 850 THEN '800-850_Excellent' 
    END AS credit_risk_score
FROM DataTest1.dbo.users_data
WHERE credit_score BETWEEN 300 AND 579  
```

###### 4.2.1. Data Cards
_1. Memilih kolom yang digunakan_
```
select id, client_id, acct_open_date, year_pin_last_changed, card_on_dark_web from DataTest1.dbo.cards_data
```
_2.Menyesuaikan isi kolom yang dibutuhkan_
```
SELECT 
    id,
    client_id,
    SUBSTRING(acct_open_date, 4, 4) AS acct_open_year,
	year_pin_last_changed,
	card_on_dark_web
FROM DataTest1.dbo.cards_data;
```
_3. Menambahkan kolom selisih_
```
SELECT 
    id,
    client_id,
    SUBSTRING(acct_open_date, 4, 4) AS acct_open_year,
	year_pin_last_changed,
    CAST(year_pin_last_changed AS INT) - CAST(SUBSTRING(acct_open_date, 4, 4) AS INT) AS gap_year,
	card_on_dark_web
FROM DataTest1.dbo.cards_data;
```
_4. Melihat distribusi range tahun para nasabah melakukan penggantian password_
```
WITH total_user AS (
    SELECT 
        id,
        CAST(year_pin_last_changed AS INT) - CAST(SUBSTRING(acct_open_date, 4, 4) AS INT) AS gap_year
    FROM DataTest1.dbo.cards_data
)
SELECT gap_year, COUNT(*) AS jumlah_orang
FROM total_user
GROUP BY gap_year
ORDER BY gap_year
```
_5. Melihat nasabah yng terdaftar darkweb_
```
SELECT 
    card_on_dark_web, 
    COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.cards_data
GROUP BY card_on_dark_web;
```

###### 4.2.3. Data Transaksi
_1. Melihat data yang akan digunakan_
```
SELECT id, date, use_chip, errors FROM DataTest1.dbo.transaction2018_2019
``` 

_2. Melihat distribusi jenis transaksi_
```
SELECT use_chip, COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.transaction2018_2019
GROUP BY use_chip
ORDER BY jumlah_orang DESC
```

_3. Melihat yang nilai-nilai kolom error selain nilai 'No Error'_
```
SELECT id, client_id, card_id, date, use_chip, amount, errors
FROM DataTest1.dbo.transaction2018_2019
WHERE errors != 'No Error'
```

_4. Melihat distribusi kendala transaksi_
```
SELECT errors, COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.transaction2018_2019
GROUP BY errors
ORDER BY jumlah_orang DESC 

```


## 5. Insight dan Analisis
Berdasarkan data sumber yang didapatkan beserta goals probelm statement yang dirumuskan sebagai berikut

1. Berapa jumlah nasabah yang terdaftar berdasarkan umur dan presentase para nasabah secara skala credit score?
-->Jumlah Nasabah terdaftar adalah 2000 Nasabah, para nasabah memiliki skor kredit yang baik mencapai 46.6% dan resentase para nasabah yang memiliki skor kredit buruk sebesar 4%. Dapat disimpulkan reputasi bank terhadap kredit skor para nasabah mendominasi kredit skor baik serta produk pinjaman atau pengelolaan keuangan yang mampu mendorong para nasabah untuk terjadi gagal bayar
2. Bagaimana perilaku para nasabah terhadap awareness keamanan data bank dengan penggantian password kartu bank?
--> Jumlah kartu nasabah yang melakukan pergantian password dibawah 1 tahun (gap_year=0) masih mendominasi sebesar 3.247 kartu nasabah dibandingkan kartu nasabah yang melakukan pergantian password lebih 1 tahun. Dapat disimpulkan para nasabah memiliki awareness terhadap penggantian password kartu bank untuk menghindari kejahatan bank secara digital
3. Bagaimana perilaku para nasabah terhadap kemudahan produk transaksional bank terhadap aktivitas transaksi para nasabah pada rentang 2018-2019?
-->Berdasarkan jenis kartu, penggunaan chip transaction saat transaksi menunjukkan jumlah tertinggi mencapai 71%. Dapat disimpulkan para Nasabah Bank MandiriSekuritas memiliki kenyamanan dalam bertransaksi menggunakan Chip Transaction
Jumlah transaksi para nasabah tanpa kendala sebanyak masih mendominasi sebanyak 1.374.508 aktivitas. Sedangkan aktivitas transaksi disebabkan beragam kendala sebanyak 22.346 merepresentasikan 1.61% jumlah kendala dengan keseluruhan aktivitas transaksi . Kendala yang paling terjadi saat nasabah transaksi adalah 'Insufficient Balance’, ‘Bad Pin’ serta ‘Technical Glitch’. Dimana kemungkinan sering terjadi karena kendala nasabah tidak memiliki saldo dan kesalahan PIN kartu

## 6. Evaluasi
1. Menganalisa lanjut terhadap para nasabah yang memiliki skor kredit buruk terhadap aktivitas transaksi
2. Menganalisa lanjut pada para nasabah yang melakukan penggantian password diatas 1 tahun
3. Menganalisa lanjut kendala transaksional bank terhadap jenis kartu dan kredit skor





















 
