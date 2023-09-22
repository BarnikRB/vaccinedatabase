select * from
(
SELECT
  ssno,
  name,
  dateofbirth,
  gender,
  CASE
    WHEN vaxcount = doses THEN 1
    WHEN vaxcount != doses THEN 0
  END vaxStatus
FROM 
  Patients
NATURAL JOIN (
  SELECT
    *
  FROM
    (
    SELECT
      patientssno AS ssno,
      COUNT(*) AS vaxCount
    FROM
      VaccinePatients
    GROUP BY 
      patientssno) AS t1
  NATURAL JOIN(
    SELECT 
      DISTINCT ssno,
      doses
    FROM
      (
      SELECT
        patientssno as ssno,
        TYPE
      FROM
      ( VaccinePatients NATURAL JOIN Vaccinations) AS v, VaccineBatch b 
      WHERE
        v.batchid = b.batchid) AS t1
        
    INNER JOIN VaccineType ON VaccineType.id = type )AS t2) AS T2


) as foo;
