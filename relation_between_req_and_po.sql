SELECT prha.segment1 "REQ NUM", pha.segment1 "PO NUM"
  FROM po_headers_all pha,
       po_distributions_all pda,
       po_req_distributions_all prda,
       po_requisition_lines_all prla,
       po_requisition_headers_all prha
 WHERE     pha.po_header_id = pda.po_header_id
       AND pda.req_distribution_id = prda.distribution_id
       AND prda.requisition_line_id = prla.requisition_line_id
       AND prla.requisition_header_id = prha.requisition_header_id
