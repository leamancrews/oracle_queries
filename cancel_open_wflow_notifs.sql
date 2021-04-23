SET SERVEROUTPUT ON;
DECLARE
    l_result                   VARCHAR2(20);
    l_item_type                WF_ITEMS.ITEM_TYPE%TYPE  := NULL;
    l_item_key                 WF_ITEMS.ITEM_KEY%TYPE   := NULL;
    l_records_exists VARCHAR2(1);
    
    CURSOR open_notifications_non_LS
    IS
        SELECT DISTINCT wn.message_type item_type,
               wn.item_key,
               wn.notification_id
         FROM wf_notifications wn,
              WF_ITEM_ATTRIBUTE_VALUES wiav
        WHERE wn.message_type      IN ( 'POSCHORD', 'APINV') --Give WF: ITEM_TYPE
          AND wn.status            = 'OPEN'
          AND wn.message_type      = wiav.item_type
          AND wn.item_key          = wiav.item_key
          AND wiav.name            IN ('ORG_ID', 'APINV_AOI') --Give Attribute Names
          AND wiav.number_value    IN (1686,1687)                 --Give Condition         
        ORDER BY wn.message_type,
                 wn.item_key,
                 wn.notification_id;
 
    CURSOR open_notifications_all
    IS
        SELECT DISTINCT wn.message_type item_type,
               wn.item_key,
               wn.notification_id
         FROM wf_notifications wn
        WHERE wn.message_type   IN ('POSASNNB', 'IBEALERT')    --Give Message Type
          AND wn.status         = 'OPEN'        
        ORDER BY wn.message_type,
                 wn.item_key,
                 wn.notification_id;
 
BEGIN
    dbms_output.put_line('Starts..');
 
    /* ------------Workflows and notifications for all orgs excluding LifeSize OU org */
    dbms_output.put_line('Processing Workflows and notifications for all orgs excluding Given??? orgs ');
    FOR i IN open_notifications_non_LS
    LOOP
 
        dbms_output.put_line('    Calling cancel workflow notification for item_type: '||i.item_type|| 
         ' item_key: '||i.item_key|| ' notification_id: '||i.notification_id);
        BEGIN
            WF_NOTIFICATION.cancel(i.notification_id,'testing');
            UPDATE WF_NOTIFICATIONS
               SET mail_status = 'SENT'
             WHERE notification_id = i.notification_id; 
           --If it is not updated then an email would be sent to the original recipient with warning notification cancelled.
        EXCEPTION
            WHEN OTHERS 
            THEN
                dbms_output.put_line('    Exception occured while cancelling notification for item_type: '||i.item_type||
                ' item_key: '||i.item_key|| ' notification_id: '||i.notification_id);
                dbms_output.put_line('        Error message : '||SQLERRM);
        END;
 
        IF (l_item_type IS NULL OR l_item_key IS NULL) 
        THEN
            l_records_exists := 'Y';
            l_item_type      := i.item_type;
            l_item_key       := i.item_key;
        END IF;
 
        IF (l_item_type <> i.item_type OR l_item_key <> i.item_key) 
        THEN
            dbms_output.put_line('    Calling Abort complete workflow for item_type: '||l_item_type||
            ' item_key: '||l_item_key);
            BEGIN
                WF_ENGINE.AbortProcess(l_item_type, l_item_key, NULL, l_result);
                dbms_output.put_line('        Successfully aborted workflow');
                dbms_output.put_line('    ----------------------------------------------------');
            EXCEPTION
                WHEN OTHERS 
                THEN
                    dbms_output.put_line('        Exception occured while Aborting workflow for item_type: '||l_item_type|| 
                    ' item_key: '||l_item_key);
                    dbms_output.put_line('        Error message : '||SQLERRM);
                    dbms_output.put_line('    ----------------------------------------------------');
            END;
            l_item_type := i.item_type;
            l_item_key    := i.item_key;
        END IF;
    END LOOP; --open_notifications_non_LS
 
    IF (nvl(l_records_exists,'N') = 'Y') THEN
        dbms_output.put_line('    Calling Abort complete workflow for last item_type: '||l_item_type||
	' item_key: '||l_item_key);
        BEGIN
            WF_ENGINE.AbortProcess(l_item_type, l_item_key, NULL, l_result);
            dbms_output.put_line('        Successfully aborted workflow');
            dbms_output.put_line('    ----------------------------------------------------');
        EXCEPTION
        WHEN OTHERS 
        THEN
            dbms_output.put_line('        Exception occured while Aborting workflow for last item_type: '||l_item_type|| 
            ' item_key: '||l_item_key);
            dbms_output.put_line('        Error message : '||SQLERRM);
            dbms_output.put_line('    ----------------------------------------------------');
        END;
    END IF;
        
    /* ------------Workflows and notifications for all orgs */
    dbms_output.put_line('*****************************************************************************');
    dbms_output.put_line('Processing Workflows and notifications for all orgs ');
    dbms_output.put_line('*****************************************************************************');
    
    l_item_type := NULL;
    l_item_key := NULL;
    l_records_exists := NULL;
    
    FOR i IN open_notifications_all
    LOOP
        dbms_output.put_line('    Calling cancel workflow notification for item_type: '||i.item_type|| 
        ' item_key: '||i.item_key|| ' notification_id: '||i.notification_id);
        BEGIN
            WF_NOTIFICATION.cancel(i.notification_id,'testing');
        EXCEPTION
            WHEN OTHERS 
            THEN
                dbms_output.put_line('    Exception occured while cancelling notification for item_type: '||i.item_type||
                ' item_key: '||i.item_key|| ' notification_id: '||i.notification_id);
                dbms_output.put_line('        Error message : '||SQLERRM);	    
        END;
 
        IF (l_item_type IS NULL OR l_item_key IS NULL) THEN
            l_records_exists := 'Y';
            l_item_type     := i.item_type;
            l_item_key        := i.item_key;	    
        END IF;
 
        IF (l_item_type <> i.item_type OR l_item_key <> i.item_key) THEN
            dbms_output.put_line('    Calling Abort complete workflow for item_type: '||l_item_type|| ' item_key: '||l_item_key);
            BEGIN
                WF_ENGINE.AbortProcess(l_item_type, l_item_key, NULL, l_result);
                dbms_output.put_line('        Successfully aborted workflow');
                dbms_output.put_line('    ----------------------------------------------------');
            EXCEPTION
                WHEN OTHERS 
                THEN
                    dbms_output.put_line('        Exception occured while Aborting workflow for item_type: '||l_item_type|| 
                    ' item_key: '||l_item_key);
                    dbms_output.put_line('        Error message : '||SQLERRM);
                    dbms_output.put_line('    ----------------------------------------------------');
            END;
            l_item_type := i.item_type;
            l_item_key    := i.item_key;	    
        END IF;
    END LOOP; --open_notifications_all
    
    IF (nvl(l_records_exists,'N') = 'Y') THEN
        dbms_output.put_line('    Calling Abort complete workflow for last item_type: '||l_item_type|| ' item_key: '||l_item_key);
        BEGIN
            WF_ENGINE.AbortProcess(l_item_type, l_item_key, NULL, l_result);
            dbms_output.put_line('        Successfully aborted workflow');
            dbms_output.put_line('    ----------------------------------------------------');
        EXCEPTION
            WHEN OTHERS 
            THEN
                dbms_output.put_line('        Exception occured while Aborting workflow for last item_type: '||l_item_type|| 
                ' item_key: '||l_item_key);
                dbms_output.put_line('        Error message : '||SQLERRM);
                dbms_output.put_line('    ----------------------------------------------------');
        END;
    END IF;
 
    COMMIT; --We can do an explicit Commit
    dbms_output.put_line('Completed');
EXCEPTION
    WHEN OTHERS 
    THEN
        dbms_output.put_line('Exception :'||SQLERRM);
END;