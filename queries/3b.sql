SELECT
    Q1.batchID,
    phone
FROM
    VaccinationStations,
    (
        SELECT
            T1.batchID,
            location AS currentLocation,
            T1.arrival AS lastLocation
        FROM
            VaccineBatch,
            TransportationLog AS T1
            INNER JOIN (
                SELECT
                    batchID,
                    MAX(dateArr) AS lastDate
                FROM
                    TransportationLog
                GROUP BY
                    batchID
            ) AS T2 ON T1.batchID = T2.batchID
            AND T1.dateArr = lastDate
        WHERE
            VaccineBatch.batchID = T1.batchID
    ) as Q1
WHERE
    Q1.currentLocation != Q1.lastLocation
    AND Q1.lastLocation = VaccinationStations.name;