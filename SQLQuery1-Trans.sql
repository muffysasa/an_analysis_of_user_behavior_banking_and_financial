--melihat semua data transaction2018-2019
SELECT * FROM DataTest1.dbo.transaction2018_2019;

--1. Melihat data yang akan digunakan
SELECT id, date, use_chip, errors FROM DataTest1.dbo.transaction2018_2019

--2. Melihat distribusi jenis transaksi
SELECT use_chip, COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.transaction2018_2019
GROUP BY use_chip
ORDER BY jumlah_orang DESC

--3. Melihat yang nilai-nilai kolom error selain nilai 'No Error'
SELECT id, client_id, card_id, date, use_chip, amount, errors
FROM DataTest1.dbo.transaction2018_2019
WHERE errors != 'No Error'

--4. Melihat distribusi kendala transaksi
SELECT errors, COUNT(*) AS jumlah_orang
FROM DataTest1.dbo.transaction2018_2019
GROUP BY errors
ORDER BY jumlah_orang DESC 
