SELECT
    P.ssNo,
    P.name,
    Vaccinations.batchID,
    VaccineBatch.type,
    VaccinePatients.date,
    VaccinePatients.location
FROM
    (
        SELECT
            Patients.name,
            Patients.ssNo,
            Diagnosis.symptom
        FROM
            Patients,
            Diagnosis
        WHERE
            Patients.ssNo = Diagnosis.patient
            AND Diagnosis.date > '2021-05-10'
        GROUP BY
            name,
            ssNo,
            symptom
        HAVING
            Diagnosis.symptom IN(
                SELECT
                    name
                FROM
                    Symptoms
                WHERE
                    criticality is True
            )
    ) AS P,
    Vaccinations,
    VaccineBatch,
    VaccinePatients
WHERE
    VaccinePatients.patientSsNo = P.ssNo
    AND Vaccinations.batchID = VaccineBatch.batchID
    AND Vaccinations.location = VaccinePatients.location
    AND Vaccinations.date = VaccinePatients.date;