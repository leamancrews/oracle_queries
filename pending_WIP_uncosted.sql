SELECT COUNT(1), mp.organization_code
  FROM wip_cost_txn_interface_v wct, 
       mtl_parameters mp
 WHERE wct.organization_id = mp.organization_id
 GROUP BY mp.organization_code;