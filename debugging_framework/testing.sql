-- test logging functionality for the debugging framework
BEGIN
    debug_utils.enable_debug;
    debug_utils.log_msg('TEST_MODULE', 10, 'Framework test started');
    debug_utils.log_variable('TEST_MODULE', 11, 'v_test', '123');
    debug_utils.log_error('TEST_MODULE', 'Sample error message');
    debug_utils.disable_debug;
END;
/

-- Query the debug_log table to verify the logged messages
SELECT log_id,
       log_time,
       log_level,
       module_name,
       line_no,
       log_message,
       session_id
FROM debug_log
ORDER BY log_id;