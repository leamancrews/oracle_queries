SELECT wias.item_key,
         wpa.activity_name,
         wias.activity_status,
         wias.activity_result_code,
         wias.assigned_user,
         wias.begin_date,
         wias.end_date
    FROM WF_ITEM_ACTIVITY_STATUSES wias, WF_PROCESS_ACTIVITIES wpa
   WHERE     wias.process_activity = wpa.instance_id(+)
         AND wpa.process_item_type = wias.item_type
         AND wias.ACTIVITY_STATUS = 'ERROR'
         AND wias.end_date IS NULL
         AND wias.item_key = TO_CHAR (12345)           -- Header_id or Line_id
ORDER BY begin_date DESC
