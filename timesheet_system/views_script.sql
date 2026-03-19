-- =====================================================
-- VIEW: vw_employee_timesheet_summary
-- Shows total logged hours for each employee timesheet
-- =====================================================
CREATE OR REPLACE VIEW vw_employee_timesheet_summary AS
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    t.timesheet_id,
    t.week_start_date,
    t.week_end_date,
    t.status,
    SUM(te.hours_worked) AS total_hours
FROM employee e
JOIN timesheet t
    ON e.employee_id = t.employee_id
JOIN timesheet_entry te
    ON t.timesheet_id = te.timesheet_id
GROUP BY
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    t.timesheet_id,
    t.week_start_date,
    t.week_end_date,
    t.status;

-- This query displays the content of the employee timesheet summary view,
-- showing total hours logged for each timesheet.
SELECT *
FROM vw_employee_timesheet_summary
ORDER BY employee_id, week_start_date;

-- =====================================================
-- MATERIALIZED VIEW: mv_monthly_employee_project_hours
-- Stores precomputed monthly total hours by employee and project
-- =====================================================
CREATE MATERIALIZED VIEW mv_monthly_employee_project_hours
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    p.project_id,
    p.project_code,
    p.project_name,
    TRUNC(te.work_date, 'MM') AS work_month,
    SUM(te.hours_worked) AS total_hours
FROM employee e
JOIN timesheet t
    ON e.employee_id = t.employee_id
JOIN timesheet_entry te
    ON t.timesheet_id = te.timesheet_id
JOIN project p
    ON te.project_id = p.project_id
GROUP BY
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    p.project_id,
    p.project_code,
    p.project_name,
    TRUNC(te.work_date, 'MM');

-- This query displays the monthly aggregated hours per employee and project
-- from the materialized view.
SELECT *
FROM mv_monthly_employee_project_hours
ORDER BY employee_id, work_month, project_id;

-- it doesn't refresh automatically, so we need to manually refresh it when needed
-- REFRESH MATERIALIZED VIEW mv_monthly_employee_project_hours;
BEGIN
    DBMS_MVIEW.REFRESH('MV_MONTHLY_EMPLOYEE_PROJECT_HOURS');
END;
/
