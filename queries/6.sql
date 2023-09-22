SELECT
    location,
    SUM(amount) AS totalVaccines,
    COUNT(DISTINCT type) AS vaccineTypes
FROM
    VaccineBatch
GROUP BY
    location;
