SELECT COUNT(1), mp.organization_code
  FROM mtl_transactions_temp_all_v mtta,
       mtl_parameters mp
 WHERE 1 = 1
   AND mtta.organization_id = mp.organization_id
 GROUP BY mp.organization_code;