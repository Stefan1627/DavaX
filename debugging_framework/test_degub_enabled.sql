-- test to verify that debug messages are logged when debugging is enabled
BEGIN
    debug_utils.enable_debug;
    adjust_salaries_by_commission;
    debug_utils.disable_debug;
END;
/

SELECT log_id,
       TO_CHAR(log_time, 'YYYY-MM-DD HH24:MI:SS') AS log_time,
       log_level,
       module_name,
       line_no,
       log_message
FROM debug_log
ORDER BY log_id;

SELECT employee_id, salary, commission_pct
FROM employees
ORDER BY employee_id;