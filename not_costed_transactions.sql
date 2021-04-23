SELECT COUNT(1), mp.organization_code
  FROM mtl_material_transactions mmt,
       mtl_parameters mp
 WHERE mmt.organization_id = mp.organization_id
   AND costed_flag = 'N'
 GROUP BY mp.organization_code;