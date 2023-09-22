WITH T1 AS(
    SELECT
        v.patientssno AS pid,
        name AS VaccineName,
        symptom
    from
        (
            VaccinePatients v
            INNER JOIN Vaccinations e ON v.location = e.location
            and e.date = v.date 
            INNER JOIN VaccineBatch on e.batchid = VaccineBatch.batchid
            INNER JOIN vaccinetype ON vaccinetype.id = VaccineBatch.type
        ),
        diagnosis c
    WHERE
        c.patient = v.patientssno
        AND c.date > v.date
),
T2 AS(
    SELECT
        VaccineName,
        COUNT(*) AS count
    FROM
        T1
    GROUP BY
        VaccineName
),
T3 AS(
    SELECT
        VaccineName,
        symptom,
        COUNT(*) AS count
    FROM
        T1
    GROUP BY
        VaccineName,
        symptom
)
SELECT
    T2.VaccineName,
    T3.symptom,
    ROUND(1.0 * T3.count / T2.count, 4) AS Frequency
FROM
    T3
    INNER JOIN T2 ON T3.VaccineName = T2.VaccineName;