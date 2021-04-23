SELECT COUNT(1), mp.organization_code
  FROM wsh_delivery_details     wdd
      ,oe_order_headers_all     ooh
      ,oe_order_lines_all       ool
      ,wsh_delivery_assignments wda
      ,wsh_new_deliveries       wnd
      ,mtl_parameters           mp
 WHERE wdd.source_header_id = ooh.header_id
   AND wdd.source_line_id = ool.line_id
   AND ooh.header_id = ool.header_id
   AND wdd.delivery_detail_id = wda.delivery_detail_id
   AND wda.delivery_id = wnd.delivery_id
   AND wdd.source_code = 'OE'
   AND wdd.released_status = 'C'
   AND wdd.inv_interfaced_flag IN ('N', 'P')
   AND wnd.status_code IN ('CL', 'IT')
   AND wdd.organization_id =mp.organization_id
 GROUP BY mp.organization_code;
