
SELECT
    StaffMembers.socialsecuritynumber,
    StaffMembers.name,
    StaffMembers.phone,
    StaffMembers.role,
    StaffMembers.vaccinationstatus,
    StaffMembers.role
FROM
    StaffMembers
    JOIN (
        SELECT
            worker,
            station,
            CASE
                WHEN weekday = 'Sunday' THEN 0
                WHEN weekday = 'Monday' THEN 1
                WHEN weekday = 'Tuesday' THEN 2
                WHEN weekday = 'Wednesday' THEN 3
                WHEN weekday = 'Thursday' THEN 4
                WHEN weekday = ' Friday' THEN 5
                WHEN weekday = 'Saturday' THEN 6
            END AS dow_no
        FROM
            Shifts
    ) shift ON StaffMembers.socialsecuritynumber = shift.worker
    JOIN (
        SELECT
            date,
            extract(
                dow
                from
                    date
            ) AS wd,
            location
        FROM
            Vaccinations
    ) event ON shift.dow_no = event.wd
    and shift.station = event.location
WHERE
    event.date = '2021-05-10';