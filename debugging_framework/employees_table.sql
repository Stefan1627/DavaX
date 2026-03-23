-- create a sample employees table and insert some data for testing
CREATE TABLE employees (
    employee_id     NUMBER PRIMARY KEY,
    first_name      VARCHAR2(50),
    last_name       VARCHAR2(50),
    salary          NUMBER(10,2) NOT NULL,
    commission_pct  NUMBER(4,2)
);

INSERT INTO employees (employee_id, first_name, last_name, salary, commission_pct)
VALUES (100, 'John', 'Smith', 5000, 0.10);

INSERT INTO employees (employee_id, first_name, last_name, salary, commission_pct)
VALUES (101, 'Ana', 'Popescu', 6000, NULL);

INSERT INTO employees (employee_id, first_name, last_name, salary, commission_pct)
VALUES (102, 'Mihai', 'Ionescu', 4500, 0.20);

INSERT INTO employees (employee_id, first_name, last_name, salary, commission_pct)
VALUES (103, 'Maria', 'Georgescu', 7000, NULL);

COMMIT;

SELECT employee_id,
       first_name,
       last_name,
       salary,
       commission_pct
FROM employees
ORDER BY employee_id;

-- create a backup of the employees table before testing the logging framework
CREATE TABLE employees_backup AS
SELECT * FROM employees;