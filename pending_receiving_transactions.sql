SELECT COUNT(1), mp.organization_code
  FROM rcv_transactions_interface rti,
       mtl_parameters mp
 WHERE rti.to_organization_id = mp.organization_id
   AND rti.processing_status_code = 'PENDING'
 GROUP BY mp.organization_code;