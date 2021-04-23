SELECT COUNT(1), mp.organization_code
  FROM mtl_transactions_interface_v mtiv,
       mtl_parameters mp
 WHERE 1 = 1
   AND mtiv.organization_id=mp.organization_id
   AND (process_flag = 3 or lock_flag = 1)
 GROUP BY mp.organization_code;