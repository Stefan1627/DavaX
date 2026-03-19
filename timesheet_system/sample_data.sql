-- =====================================================
-- TIMESHEET SYSTEM
-- SAMPLE DATA INSERTS
-- =====================================================

-- =====================================================
-- 1. DEPARTMENT DATA
-- =====================================================
INSERT INTO department (department_name, cost_center, created_at)
VALUES ('Engineering', 'CC1001', SYSDATE);

INSERT INTO department (department_name, cost_center, created_at)
VALUES ('Quality Assurance', 'CC1002', SYSDATE);

INSERT INTO department (department_name, cost_center, created_at)
VALUES ('Operations', 'CC1003', SYSDATE);

-- =====================================================
-- 2. EMPLOYEE DATA
-- Note:
-- department_id values assume identity generation started at 1
-- based on insert order above:
-- 1 = Engineering
-- 2 = Quality Assurance
-- 3 = Operations
-- =====================================================
INSERT INTO employee (
    department_id,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    profile_json
)
VALUES (
    1,
    'E001',
    'Andrei',
    'Popescu',
    'andrei.popescu@company.com',
    DATE '2023-01-10',
    'ACTIVE',
    '{"phone":"0711111111","skills":["Oracle SQL","PLSQL","Data Modeling"],"level":"Senior"}'
);

INSERT INTO employee (
    department_id,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    profile_json
)
VALUES (
    1,
    'E002',
    'Maria',
    'Ionescu',
    'maria.ionescu@company.com',
    DATE '2023-03-15',
    'ACTIVE',
    '{"phone":"0722222222","skills":["Backend","API","SQL"],"level":"Mid"}'
);

INSERT INTO employee (
    department_id,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    profile_json
)
VALUES (
    2,
    'E003',
    'Vlad',
    'Georgescu',
    'vlad.georgescu@company.com',
    DATE '2022-11-01',
    'ACTIVE',
    '{"phone":"0733333333","skills":["Testing","Automation","Selenium"],"level":"Senior"}'
);

INSERT INTO employee (
    department_id,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    profile_json
)
VALUES (
    3,
    'E004',
    'Elena',
    'Dumitru',
    'elena.dumitru@company.com',
    DATE '2024-02-20',
    'ON_LEAVE',
    '{"phone":"0744444444","skills":["Support","ITIL"],"level":"Junior"}'
);

INSERT INTO employee (
    department_id,
    employee_code,
    first_name,
    last_name,
    email,
    hire_date,
    employment_status,
    profile_json
)
VALUES (
    2,
    'E005',
    'Radu',
    'Matei',
    'radu.matei@company.com',
    DATE '2024-05-05',
    'ACTIVE',
    '{"phone":"0755555555","skills":["Manual Testing","Reporting"],"level":"Junior"}'
);

-- =====================================================
-- 3. PROJECT DATA
-- =====================================================
INSERT INTO project (
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
)
VALUES (
    'P001',
    'Timesheet Platform',
    DATE '2025-01-01',
    NULL,
    'ACTIVE',
    1200
);

INSERT INTO project (
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
)
VALUES (
    'P002',
    'Internal QA Automation',
    DATE '2025-02-01',
    NULL,
    'ACTIVE',
    800
);

INSERT INTO project (
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
)
VALUES (
    'P003',
    'Infrastructure Migration',
    DATE '2024-10-01',
    DATE '2025-12-31',
    'ACTIVE',
    1500
);

INSERT INTO project (
    project_code,
    project_name,
    start_date,
    end_date,
    project_status,
    budget_hours
)
VALUES (
    'P004',
    'Archived Reporting Tool',
    DATE '2024-01-01',
    DATE '2024-12-31',
    'CLOSED',
    500
);

-- =====================================================
-- 4. TIMESHEET DATA
-- Note:
-- employee_id values assume identity generation started at 1
-- based on insert order above:
-- 1 = Andrei
-- 2 = Maria
-- 3 = Vlad
-- 4 = Elena
-- 5 = Radu
--
-- Radu (employee_id = 5) intentionally has no timesheet,
-- useful for LEFT JOIN examples.
-- =====================================================
INSERT INTO timesheet (
    employee_id,
    week_start_date,
    week_end_date,
    status,
    submitted_at
)
VALUES (
    1,
    DATE '2026-03-02',
    DATE '2026-03-08',
    'APPROVED',
    DATE '2026-03-09'
);

INSERT INTO timesheet (
    employee_id,
    week_start_date,
    week_end_date,
    status,
    submitted_at
)
VALUES (
    2,
    DATE '2026-03-02',
    DATE '2026-03-08',
    'SUBMITTED',
    DATE '2026-03-09'
);

INSERT INTO timesheet (
    employee_id,
    week_start_date,
    week_end_date,
    status,
    submitted_at
)
VALUES (
    3,
    DATE '2026-03-02',
    DATE '2026-03-08',
    'APPROVED',
    DATE '2026-03-09'
);

INSERT INTO timesheet (
    employee_id,
    week_start_date,
    week_end_date,
    status,
    submitted_at
)
VALUES (
    1,
    DATE '2026-03-09',
    DATE '2026-03-15',
    'DRAFT',
    NULL
);

INSERT INTO timesheet (
    employee_id,
    week_start_date,
    week_end_date,
    status,
    submitted_at
)
VALUES (
    4,
    DATE '2026-03-02',
    DATE '2026-03-08',
    'REJECTED',
    DATE '2026-03-09'
);

-- =====================================================
-- 5. TIMESHEET_ENTRY DATA
-- Note:
-- Assumed generated IDs:
-- timesheet_id:
-- 1 = Andrei, week of 2026-03-02
-- 2 = Maria,  week of 2026-03-02
-- 3 = Vlad,   week of 2026-03-02
-- 4 = Andrei, week of 2026-03-09
-- 5 = Elena,  week of 2026-03-02
--
-- project_id:
-- 1 = Timesheet Platform
-- 2 = Internal QA Automation
-- 3 = Infrastructure Migration
-- 4 = Archived Reporting Tool
-- =====================================================

-- Entries for timesheet 1 (Andrei)
INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    1,
    1,
    DATE '2026-03-02',
    8,
    'DEV',
    'Implemented employee module',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    1,
    1,
    DATE '2026-03-03',
    7.5,
    'DEV',
    'Worked on timesheet validation logic',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    1,
    3,
    DATE '2026-03-04',
    4,
    'MEETING',
    'Migration planning meeting',
    'N'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    1,
    1,
    DATE '2026-03-05',
    8,
    'DOC',
    'Updated technical documentation',
    'Y'
);

-- Entries for timesheet 2 (Maria)
INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    2,
    1,
    DATE '2026-03-02',
    6,
    'DEV',
    'Built project setup scripts',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    2,
    1,
    DATE '2026-03-03',
    8,
    'DEV',
    'Worked on REST integration',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    2,
    3,
    DATE '2026-03-06',
    5,
    'SUPPORT',
    'Assisted migration support tasks',
    'N'
);

-- Entries for timesheet 3 (Vlad)
INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    3,
    2,
    DATE '2026-03-02',
    8,
    'TEST',
    'Created automation test cases',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    3,
    2,
    DATE '2026-03-03',
    8,
    'TEST',
    'Executed regression test suite',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    3,
    2,
    DATE '2026-03-04',
    6,
    'DOC',
    'Prepared QA execution report',
    'N'
);

-- Entries for timesheet 4 (Andrei, next week)
INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    4,
    1,
    DATE '2026-03-09',
    8,
    'DEV',
    'Continued work on approval flow',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    4,
    1,
    DATE '2026-03-10',
    8,
    'DEV',
    'Implemented status transitions',
    'Y'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    4,
    3,
    DATE '2026-03-11',
    2.5,
    'MEETING',
    'Cross-team dependency discussion',
    'N'
);

-- Entries for timesheet 5 (Elena)
INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    5,
    3,
    DATE '2026-03-02',
    4,
    'SUPPORT',
    'Handled migration support tickets',
    'N'
);

INSERT INTO timesheet_entry (
    timesheet_id,
    project_id,
    work_date,
    hours_worked,
    task_type,
    work_description,
    billable_flag
)
VALUES (
    5,
    4,
    DATE '2026-03-03',
    3,
    'DOC',
    'Reviewed archived reporting documentation',
    'N'
);

COMMIT;