select 
invoice_num, doc.uri
from ap_invoices_all ap
INNER JOIN FND_ATTACHED_DOCUMENTS att on ap.invoice_id = att.pk1_value 
INNER JOIN FND_DOCUMENTS_tl doc on att.attached_document_id = doc.document_id
and att.entity_name = 'AP_INVOICES_ALL'

