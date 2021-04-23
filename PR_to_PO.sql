SELECT prh.requisition_number
,prl.line_number
,prl.line_status
,prl.req_po_instance_id
,prl.reqs_in_pool_flag
,ph.segment1 AS po_number
,prh.emergency_po_number
,prl.reqtopo_automation_failed
,prl.reqtopo_auto_failed_reason
,msg.context AS failed_reason_text
,DECODE(NVL2(prh.EMERGENCY_PO_NUMBER, 1, - 1), 1, prh.SOLDTO_LE_ID, - 1,
NULL) AS SOLDTO_LE_ID
,prh.pcard_id
,prl.line_type_id
,prl.pcard_flag
,prl.requisition_header_id
,prl.requisition_line_id
,prl.prc_bu_id AS req_line_prc_bu
,prh.prc_bu_id AS req_header_prc_bu
,prl.req_bu_id
,prl.assigned_buyer_id
,prl.negotiated_by_preparer_flag
,prl.negotiation_required_flag
,prl.source_document_type
,prl.source_doc_header_id
,prl.vendor_id
,prl.vendor_site_id
,prl.line_location_id
,prl.item_id
,prl.category_id
,prl.amount
,prl.quantity
,prl.unit_price
,ph.document_creation_method
,ph.prc_bu_id AS po_prc_bu
,ph.document_status
,ph.po_header_id

FROM po_headers_all ph
,po_lines_draft_all pl
,por_requisition_lines_all prl
,por_requisition_headers_all prh
,fnd_messages_b msg

WHERE ph.po_header_id(+) = pl.po_header_id
AND prl.po_line_id = pl.po_line_id(+)
AND prl.requisition_header_id = prh.requisition_header_id
-- AND prh.requisition_number IN ('RQ17135')
AND prl.reqtopo_auto_failed_reason = msg.message_name(+)

ORDER BY prl.requisition_header_id, prl.line_number; 
