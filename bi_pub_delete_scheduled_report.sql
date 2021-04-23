SET VERIFY ON
WHENEVER SQLERROR EXIT ROLLBACK;

ACCEPT job_number PROMPT 'Enter job number to be deleted from quartz:';

delete from qrtz_cron_triggers where trigger_name = '&job_number';
delete from qrtz_simple_triggers where trigger_name = '&job_number';
delete from qrtz_triggers where trigger_name = '&job_number';
delete from qrtz_job_details where job_name = '&job_number';

commit;