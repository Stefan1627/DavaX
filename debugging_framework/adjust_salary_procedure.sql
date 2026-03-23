-- This procedure adjusts employee salaries based on their commission percentage.
-- If commission_pct is not NULL, salary is increased by that percentage.
-- If commission_pct is NULL, salary is increased by a default of 2%.
CREATE OR REPLACE PROCEDURE adjust_salaries_by_commission IS
    CURSOR c_emp IS
        SELECT employee_id,
               salary,
               commission_pct
        FROM employees
        FOR UPDATE OF salary;

    v_new_salary employees.salary%TYPE;
BEGIN
    debug_utils.log_msg('ADJUST_SALARIES_BY_COMMISSION', 10, 'Procedure started');

    -- Loop through each employee and adjust salary based on commission percentage
    FOR r_emp IN c_emp LOOP
        debug_utils.log_msg(
            'ADJUST_SALARIES_BY_COMMISSION',
            15,
            'Processing employee_id = ' || r_emp.employee_id
        );

        debug_utils.log_variable(
            'ADJUST_SALARIES_BY_COMMISSION',
            16,
            'current_salary',
            TO_CHAR(r_emp.salary)
        );

        debug_utils.log_variable(
            'ADJUST_SALARIES_BY_COMMISSION',
            17,
            'commission_pct',
            NVL(TO_CHAR(r_emp.commission_pct), 'NULL')
        );

        -- Calculate new salary based on commission percentage
        IF r_emp.commission_pct IS NOT NULL THEN
            v_new_salary := r_emp.salary + (r_emp.salary * r_emp.commission_pct);

            debug_utils.log_msg(
                'ADJUST_SALARIES_BY_COMMISSION',
                24,
                'Commission exists. Salary increased by commission percentage.'
            );
        ELSE
            v_new_salary := r_emp.salary + (r_emp.salary * 0.02);

            debug_utils.log_msg(
                'ADJUST_SALARIES_BY_COMMISSION',
                31,
                'Commission is NULL. Salary increased by 2%.'
            );
        END IF;

        debug_utils.log_variable(
            'ADJUST_SALARIES_BY_COMMISSION',
            35,
            'new_salary',
            TO_CHAR(v_new_salary)
        );

        -- Update the employee's salary
        UPDATE employees
        SET salary = v_new_salary
        WHERE CURRENT OF c_emp;

        debug_utils.log_msg(
            'ADJUST_SALARIES_BY_COMMISSION',
            42,
            'Salary updated for employee_id = ' || r_emp.employee_id
        );
    END LOOP;

    COMMIT;

    debug_utils.log_msg('ADJUST_SALARIES_BY_COMMISSION', 48, 'Procedure completed successfully');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        debug_utils.log_error(
            'ADJUST_SALARIES_BY_COMMISSION',
            'Unhandled exception: ' || SQLERRM
        );
        RAISE;
END adjust_salaries_by_commission;
/

SHOW ERRORS;