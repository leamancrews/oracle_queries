select
    request_id,
    parent_request_id,
    fcpt.user_concurrent_program_name Request_Name,
    fcpt.user_concurrent_program_name program_name,
    DECODE(fcr.phase_code,
            'C','Completed',
            'I','Incactive',
            'P','Pending',
            'R','Running') phase,
    DECODE(fcr.status_code,
            'D','Cancelled',
            'U','Disabled',
            'E','Error',
            'M','No Manager',
            'R','Normal',
            'I','Normal',
            'C','Normal',
            'H','On Hold',
            'W','Paused',
            'B','Resuming',
            'P','Scheduled',
            'Q','Standby',
            'S','Suspended',
            'X','Terminated',
            'T','Terminating',
            'A','Waiting',
            'Z','Waiting',
            'G','Warning','N/A') status,
    round((fcr.actual_completion_date - fcr.actual_start_date),3) * 1440 as Run_Time,
    round(avg(round(to_number(actual_start_date - fcr.requested_start_date),3) * 1440),2) wait_time,
    fu.User_Name Requestor,
    fcr.argument_text parameters,
    to_char (fcr.requested_start_date, 'MM/DD HH24:mi:SS') requested_start,
    to_char(actual_start_date, 'MM/DD/YY HH24:mi:SS') ACT_START,
    to_char(actual_completion_date, 'MM/DD/YY HH24:mi:SS') ACT_COMP,
    fcr.completion_text
From
    apps.fnd_concurrent_requests fcr,
    apps.fnd_concurrent_programs fcp,
    apps.fnd_concurrent_programs_tl fcpt,
    apps.fnd_user fu
Where 1=1
    -- and fu.user_name = 'DJKOCH' '
    -- and fcr.request_id = 1565261
    -- and fcpt.user_concurrent_program_name = 'Payables Open Interface Import''
    and fcr.concurrent_program_id = fcp.concurrent_program_id
    and fcp.concurrent_program_id = fcpt.concurrent_program_id
    and fcr.program_application_id = fcp.application_id
    and fcp.application_id = fcpt.application_id
    and fcr.requested_by = fu.user_id
    and fcpt.language = 'US'
    and fcr.actual_start_date like sysdate
    -- and fcr.phase_code = 'C'
    -- and hold_flag = 'Y'
    -- and fcr.status_code = 'C'
GROUP BY
    request_id,
    parent_request_id,
    fcpt.user_concurrent_program_name,
    fcr.requested_start_date,
    fu.User_Name,
    fcr.argument_text,
    fcr.actual_completion_date,
    fcr.actual_start_date,
    fcr.phase_code,
    fcr.status_code,
    fcr.resubmit_interval,
    fcr.completion_text,
    fcr.resubmit_interval,
    fcr.resubmit_interval_unit_code,
    fcr.description
Order by 1 desc;