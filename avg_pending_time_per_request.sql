SELECT TO_CHAR (actual_start_date, 'DD-MON-YYYY') DAY,
concurrent_queue_name,
(SUM ( ( actual_start_date
- (CASE
WHEN requested_start_date > request_date
THEN requested_start_date
ELSE request_date
END
)
)
* 24
* 60
* 60
)
)
/ COUNT (*) "Wait_Time_per_Req_in_Secs"
FROM apps.fnd_concurrent_requests cr,
apps.fnd_concurrent_processes fcp,
apps.fnd_concurrent_queues fcq
WHERE cr.phase_code = 'C'
AND cr.actual_start_date IS NOT NULL
AND cr.requested_start_date IS NOT NULL
AND cr.controlling_manager = fcp.concurrent_process_id
AND fcp.queue_application_id = fcq.application_id
AND fcp.concurrent_queue_id = fcq.concurrent_queue_id
GROUP BY TO_CHAR (actual_start_date, 'DD-MON-YYYY'), concurrent_queue_name
ORDER BY 2