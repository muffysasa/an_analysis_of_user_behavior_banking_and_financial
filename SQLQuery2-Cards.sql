-- melihat semua data cards_data
select * from DataTest1.dbo.cards_data

--1. Memilih kolom yang digunakan
select id, client_id, acct_open_date, year_pin_last_changed, card_on_dark_web from DataTest1.dbo.cards_data

--2.Menyesuaikan isi kolom yang dibutuhkan
SELECT 
    id,
    client_id,
    SUBSTRING(acct_open_date, 4, 4) AS acct_open_year,
	year_pin_last_changed,
	card_on_dark_web
FROM DataTest1.dbo.cards_data;

--3. Menambahkan kolom selisih
SELECT 
    id,
    client_id,
    SUBSTRING(acct_open_date, 4, 4) AS acct_open_year,
	year_pin_last_changed,
    CAST(year_pin_last_changed AS INT) - CAST(SUBSTRING(acct_open_date, 4, 4) AS INT) AS gap_year,
	card_on_dark_web
FROM DataTest1.dbo.cards_data;

--4. Melihat distribusi range tahun para nasabah melakukan penggantian password
WITH total_user AS (
    SELECT 
        id,
		client_id,
        CAST(year_pin_last_changed AS INT) - CAST(SUBSTRING(acct_open_date, 4, 4) AS INT) AS gap_year
    FROM DataTest1.dbo.cards_data
)
SELECT gap_year, COUNT(*) AS jumlah_orang
FROM total_user
GROUP BY gap_year
ORDER BY gap_year

--5. Melihat nasabah yng terdaftar darkweb
SELECT 
    card_on_dark_web, 
    COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.cards_data
GROUP BY card_on_dark_web;




