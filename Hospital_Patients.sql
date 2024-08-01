##Berapa persentase pasien berdasarkan jenis kelamin?
SELECT gender, concat(round(count(gender)/(SELECT count(gender) FROM patients)*100,2),'%') AS percentage
FROM patients GROUP BY gender;

##Bagaimana distribusi usia pasien? Assume that the data cut-off is in 31 Dec 2022. Create view in it.
CREATE VIEW demography AS (
	SELECT YEAR(p.deathdate)-YEAR(p.birthdate) AS age, p.gender, e.REASONDESCRIPTION
    FROM patients p
    LEFT JOIN encounters e
    ON p.id = e.patient
);
SELECT age, count(age) AS count_of_age FROM demography GROUP BY age ORDER BY age ASC;

##Apa penyakit paling umum di antara pasien?
SELECT REASONDESCRIPTION, count(REASONDESCRIPTION) AS count_of_reason
FROM encounters
GROUP BY REASONDESCRIPTION
ORDER BY count_of_reason DESC;

##Bagaimana pola penyakit berdasarkan kelompok usia dan jenis kelamin? Exclude the 'No reason' values
SELECT age, count(REASONDESCRIPTION) AS count_of_reason FROM demography WHERE REASONDESCRIPTION <> 'No reason' GROUP BY age ORDER BY age ASC;
SELECT gender, count(REASONDESCRIPTION) as count_of_reason FROM demography WHERE REASONDESCRIPTION <> 'No reason' GROUP BY gender;

##Berapa rata-rata lama perawatan pasien di rumah sakit? Create view in it and exclude the 'No reason' values
CREATE VIEW patient_stay AS (
	SELECT patient, start, stop,
    datediff(date(stop),date(start)) AS days_stay,
    description, reasondescription
    FROM encounters
    WHERE REASONDESCRIPTION <> 'No reason'
);
SELECT AVG(days_stay) AS average_stay FROM patient_stay;