 h.segment1 "PO NUM",
h.authorization_status "STATUS",
l.line_num "SEQ NUM",
ll.line_location_id,
d.po_distribution_id ,
h.type_lookup_code "TYPE"
from
po.po_headers_all h,
po.po_lines_all l,
po.po_line_locations_all ll,
po.po_distributions_all d
where h.po_header_id = l.po_header_id
and ll.po_line_id = l.po_Line_id
and ll.line_location_id = d.line_location_id
and h.closed_date is null
and h.type_lookup_code not in ('QUOTATION')