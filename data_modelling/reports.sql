-- Actvities by day
SELECT
    dd.full_date,
    fa.source_system,
    SUM(fa.hours_amount) AS total_hours
FROM fact_employee_activity fa
JOIN dim_date dd
    ON fa.date_key = dd.date_key
GROUP BY dd.full_date, fa.source_system
ORDER BY dd.full_date, fa.source_system;


-- Activities by employee
SELECT
    de.employee_code,
    de.first_name,
    de.last_name,
    fa.source_system,
    SUM(fa.hours_amount) AS total_hours
FROM fact_employee_activity fa
JOIN dim_employee de
    ON fa.employee_key = de.employee_key
GROUP BY
    de.employee_code,
    de.first_name,
    de.last_name,
    fa.source_system
ORDER BY de.employee_code, fa.source_system;


-- Activities by day and employee
SELECT
    dd.full_date,
    de.employee_code,
    de.first_name || ' ' || de.last_name AS employee_name,
    fa.source_system,
    SUM(fa.hours_amount) AS total_hours
FROM fact_employee_activity fa
JOIN dim_date dd
    ON fa.date_key = dd.date_key
JOIN dim_employee de
    ON fa.employee_key = de.employee_key
GROUP BY
    dd.full_date,
    de.employee_code,
    de.first_name || ' ' || de.last_name,
    fa.source_system
ORDER BY
    dd.full_date,
    de.employee_code,
    fa.source_system;
