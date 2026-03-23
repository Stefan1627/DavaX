-- test to verify that no debug messages are logged when debugging is disabled
TRUNCATE TABLE debug_log;

BEGIN
    debug_utils.disable_debug;
    adjust_salaries_by_commission;
END;
/

SELECT COUNT(*) FROM debug_log;