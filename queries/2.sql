
SELECT
    StaffMembers.name
FROM
    StaffMembers
    JOIN Shifts ON StaffMembers.socialsecuritynumber = Shifts.worker
    JOIN VaccinationStations ON Shifts.station = VaccinationStations.name
WHERE
    Shifts.weekday = 'Wednesday'
    AND StaffMembers.role = 'doctor'
    AND VaccinationStations.address LIKE '%HELSINKI%';

