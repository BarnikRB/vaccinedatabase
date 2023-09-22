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
            MAX(datearr) AS lastDate
        FROM
            TransportationLog
        GROUP BY
            batchID
    ) AS T2 ON T1.batchID = T2.batchID
    AND T1.datearr  = lastDate
WHERE
    VaccineBatch.batchID = T1.batchID;