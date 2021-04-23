SELECT prha.*
  FROM po_Requisition_headers_all prha, po_action_history pah
 WHERE     1 = 1
       AND pah.object_id = prha.requisition_header_id
       AND action_code = 'CANCEL'
       AND pah.object_type_code = 'REQUISITION';