-- Insert data into dimension tables

-- DEPARTMENT
INSERT INTO dim_department (department_id_src, department_name, cost_center)
SELECT
    department_id,
    department_name,
    cost_center
FROM department;


-- EMPOYEE
INSERT INTO dim_employee (
    employee_id_src,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    department_key
)
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    e.email,
    e.hire_date,
    e.employment_status,
    d.department_key
FROM employee e
JOIN dim_department d
    ON e.department_id = d.department_id_src;


-- PROJECT
INSERT INTO dim_project (
    project_id_src,
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
)
SELECT
    project_id,
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
FROM project;


-- DATE
BEGIN
    FOR i IN 0 .. 30 LOOP
        INSERT INTO dim_date (
            date_key,
            full_date,
            day_number,
            month_number,
            month_name,
            quarter_number,
            year_number,
            weekday_name,
            is_weekend
        )
        VALUES (
            TO_NUMBER(TO_CHAR(DATE '2026-03-01' + i, 'YYYYMMDD')),
            DATE '2026-03-01' + i,
            TO_NUMBER(TO_CHAR(DATE '2026-03-01' + i, 'DD')),
            TO_NUMBER(TO_CHAR(DATE '2026-03-01' + i, 'MM')),
            TRIM(TO_CHAR(DATE '2026-03-01' + i, 'MONTH')),
            TO_NUMBER(TO_CHAR(DATE '2026-03-01' + i, 'Q')),
            TO_NUMBER(TO_CHAR(DATE '2026-03-01' + i, 'YYYY')),
            TRIM(TO_CHAR(DATE '2026-03-01' + i, 'DAY')),
            CASE
                WHEN TO_CHAR(DATE '2026-03-01' + i, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN')
                THEN 'Y'
                ELSE 'N'
            END
        );
    END LOOP;
END;


-- ACTIVITY TYPE
INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'WORK', 'DEV', 'Y');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'WORK', 'TEST', 'Y');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'MEETING', 'MEETING', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'WORK', 'SUPPORT', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'WORK', 'DOC', 'Y');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('TIMESHEET', 'WORK', 'DOC', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('EVENT', 'MEETING', 'MEETING', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('EVENT', 'TRAINING', 'TRAINING', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('EVENT', 'WORKSHOP', 'WORKSHOP', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('ABSENCE', 'LEAVE', 'VACATION', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('ABSENCE', 'LEAVE', 'SICK_LEAVE', 'N');

INSERT INTO dim_activity_type (source_system, activity_category, activity_subtype, billable_flag)
VALUES ('ABSENCE', 'LEAVE', 'PERSONAL_LEAVE', 'N');

SELECT * FROM dim_department;
SELECT * FROM dim_employee;
SELECT * FROM dim_project;
SELECT * FROM dim_date;
SELECT * FROM dim_activity_type;


-- Insert data into fact table from timesheet entries
INSERT INTO fact_employee_activity (
    date_key,
    employee_key,
    department_key,
    project_key,
    activity_type_key,
    source_record_id,
    source_system,
    activity_description,
    hours_amount,
    activity_count
)
SELECT
    TO_NUMBER(TO_CHAR(te.work_date, 'YYYYMMDD')) AS date_key,
    de.employee_key,
    de.department_key,
    dp.project_key,
    dat.activity_type_key,
    te.entry_id,
    'TIMESHEET',
    te.work_description,
    te.hours_worked,
    1
FROM timesheet_entry te
JOIN timesheet t
    ON te.timesheet_id = t.timesheet_id
JOIN employee e
    ON t.employee_id = e.employee_id
JOIN dim_employee de
    ON de.employee_id_src = e.employee_id
JOIN dim_project dp
    ON dp.project_id_src = te.project_id
JOIN dim_activity_type dat
    ON dat.source_system = 'TIMESHEET'
   AND dat.activity_subtype = te.task_type
   AND dat.billable_flag = te.billable_flag;


-- Insert data into fact table from event entries
INSERT INTO fact_employee_activity (
    date_key,
    employee_key,
    department_key,
    project_key,
    activity_type_key,
    source_record_id,
    source_system,
    activity_description,
    hours_amount,
    activity_count
)
SELECT
    TO_NUMBER(TO_CHAR(event_date, 'YYYYMMDD')) AS date_key,
    de.employee_key,
    de.department_key,
    NULL,
    dat.activity_type_key,
    sec.event_id,
    'EVENT',
    sec.event_name,
    sec.duration_hours,
    1
FROM stg_event_calendar sec
JOIN dim_employee de
    ON de.employee_code = sec.employee_code
JOIN dim_activity_type dat
    ON dat.source_system = 'EVENT'
   AND dat.activity_subtype = sec.event_type;


-- Insert data into fact table from absence entries
INSERT INTO fact_employee_activity (
    date_key,
    employee_key,
    department_key,
    project_key,
    activity_type_key,
    source_record_id,
    source_system,
    activity_description,
    hours_amount,
    activity_count
)
SELECT
    TO_NUMBER(TO_CHAR(absence_date, 'YYYYMMDD')) AS date_key,
    de.employee_key,
    de.department_key,
    NULL,
    dat.activity_type_key,
    sal.absence_id,
    'ABSENCE',
    sal.absence_type,
    sal.absence_hours,
    1
FROM stg_absence_log sal
JOIN dim_employee de
    ON de.employee_code = sal.employee_code
JOIN dim_activity_type dat
    ON dat.source_system = 'ABSENCE'
   AND dat.activity_subtype = sal.absence_type
WHERE sal.approval_status = 'APPROVED';

SELECT source_system, COUNT(*) AS row_count
FROM fact_employee_activity
GROUP BY source_system;

Select * from fact_employee_activity;

commit;