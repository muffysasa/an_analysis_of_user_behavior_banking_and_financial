-- melihat semua data users_data
select * from DataTest1.dbo.users_data

-- 1. melihat kolom data users_data yang dibutuhkan
select id, current_age, credit_score from DataTest1.dbo.users_data

-- 2. membuat kolom baru dan melihat data berdasarkan skala skor kredit (scoring FICO)
SELECT id, current_age, credit_score,
    CASE 
        WHEN credit_score BETWEEN 300 AND 579 THEN '300-579_Bad'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580-669_Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670-739_Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN '740-799_VeryGood'
        WHEN credit_score BETWEEN 800 AND 850 THEN '800-850_Excellent'   
    END AS credit_risk_score
FROM dbo.users_data

--3. Melihat distribusi nasabah berdasarkan umur
SELECT 
    current_age,
    COUNT(*) AS total_user
FROM DataTest1.dbo.users_data
GROUP BY current_age
ORDER BY current_age

--4. Melihat distribusi nasabah berdasarkan skor kredit
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

--5. Melihat nasabah yang memiliki kredit skor buruk
SELECT 
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

