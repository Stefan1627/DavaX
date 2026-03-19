-- This query groups timesheet entries by employee
-- and calculates the total number of hours worked by each employee.
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    SUM(te.hours_worked) AS total_hours_worked
FROM employee e
JOIN timesheet t
    ON e.employee_id = t.employee_id
JOIN timesheet_entry te
    ON t.timesheet_id = te.timesheet_id
GROUP BY
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name
ORDER BY total_hours_worked DESC;

-- This query lists all employees and their timesheets.
-- It uses LEFT JOIN so that employees without any timesheet
-- are still displayed with NULL values for timesheet columns.
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    t.timesheet_id,
    t.week_start_date,
    t.week_end_date,
    t.status
FROM employee e
LEFT JOIN timesheet t
    ON e.employee_id = t.employee_id
ORDER BY e.employee_id, t.week_start_date;

-- This query calculates the total hours worked by each employee
-- and ranks employees from highest to lowest total hours using
-- the analytic function RANK().
SELECT
    employee_id,
    employee_code,
    first_name,
    last_name,
    total_hours_worked,
    RANK() OVER (ORDER BY total_hours_worked DESC) AS hours_rank
FROM (
    SELECT
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name,
        SUM(te.hours_worked) AS total_hours_worked
    FROM employee e
    JOIN timesheet t
        ON e.employee_id = t.employee_id
    JOIN timesheet_entry te
        ON t.timesheet_id = te.timesheet_id
    GROUP BY
        e.employee_id,
        e.employee_code,
        e.first_name,
        e.last_name
)
ORDER BY hours_rank;

-- This query shows each timesheet entry together with the running total
-- of hours worked by each employee over time using the analytic function
-- SUM() OVER (...).
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    te.work_date,
    te.hours_worked,
    SUM(te.hours_worked) OVER (
        PARTITION BY e.employee_id
        ORDER BY te.work_date
    ) AS running_total_hours
FROM employee e
JOIN timesheet t
    ON e.employee_id = t.employee_id
JOIN timesheet_entry te
    ON t.timesheet_id = te.timesheet_id
ORDER BY e.employee_id, te.work_date;