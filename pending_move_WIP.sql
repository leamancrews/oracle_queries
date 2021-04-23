SELECT COUNT(1), mp.organization_code
  FROM wip_move_txn_interface_v wmt, 
       mtl_parameters mp
 WHERE wmt.organization_id = mp.organization_id 
 GROUP BY mp.organization_code;
