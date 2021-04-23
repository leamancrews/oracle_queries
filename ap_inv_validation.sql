SELECT
 
 /*+ use_hash(inv) */

to_timestamp_tz(ema.ecActionDataText1
||' UTC', 'YYYY-MM-DD HH24:MI:SS TZR') AS "Mail Received",

to_timestamp_tz(DECODE(cs.ecActionDataText5, NULL, NULL, cs.ecActionDataText5
||' UTC'), 'YYYY-MM-DD HH24:MI:SS TZR') AS "ODC",

inte.creation_date AS "Interface",

inv.creation_date AS "Invoice Creation",

ema.ecActionDataText2 AS "Received from Email",

ema.ecActionDataText3 AS "Email Subject",

pag.ecActionDataText2 AS "Name of Attachment",

DECODE(inv.invoice_id, NULL, inte.invoice_num, inv.invoice_num) AS "Invoice Number",

DECODE(inv.invoice_id, NULL, DECODE(inte.invoice_id, NULL, 'Email Received', DECODE(inte.status, 'REJECTED', 'In Interface – Rejected','PROCESSED','Deleted after Import','In Interface')), 'Completed') AS "Processing Status",

DECODE(inv.invoice_id, NULL, NULL, alc.displayed_field) AS "Invoice Status",

ema.ecBatchID AS "Batch Number ODC",

inte.request_id AS "Import Process ID",

pag.ecActionDataText1 AS "URN Number",

DECODE(inv.invoice_id,NULL,'N/A',(SELECT approvalstatus.displayed_field FROM FUSION.AP_LOOKUP_CODES approvalstatus
WHERE approvalstatus.lookup_type = 'AP_WFAPPROVAL_STATUS' AND approvalstatus.lookup_code = DECODE(inv.wfapproval_status,'STOPPED','WITHDRAWN',inv.wfapproval_status))) AS "ApprovalStatus",

DECODE(inv.invoice_id,NULL,'N/A',(SELECT invoicepaymentstatus.displayed_field FROM FUSION.AP_LOOKUP_CODES invoicepaymentstatus WHERE invoicepaymentstatus.lookup_type = 'INVOICE PAYMENT STATUS' AND invoicepaymentstatus.lookup_code = inv.payment_status_flag)) AS "PaidStatus",

DECODE(inv.invoice_id,NULL,'N/A',(SELECT asl.displayed_field FROM FUSION.AP_LOOKUP_CODES asl where asl.lookup_type = 'AP_ACCOUNTING_STATUS' AND asl.lookup_code = FUSION.ap_invoices_utility_pkg.get_accounting_status(inv.invoice_id))) AS "AccountingStatus"

FROM
 
"FUSION".ecAudit ema,
"FUSION".ecAudit pag,
"FUSION".ecAudit cs,
FUSION.AP_INVOICES_INTERFACE inte,
FUSION.AP_INVOICES_ALL inv,
FUSION.AP_LOOKUP_CODES alc

WHERE 1=1

AND ema.ecActionID         = 1001
AND ema.ecBatchID          = cs.ecBatchID(+)
AND cs.ecActionID(+)       = 13
AND ema.ecBatchID          = pag.ecBatchID(+)
AND pag.ecActionID(+)      = 1002
AND pag.ecActionDataText1  = inte.Routing_Attribute5(+)
AND inte.source(+)         = 'IMAGE'
AND pag.ecActionDataText1  = inv.Routing_Attribute5(+)
AND inv.source(+)          = 'IMAGE'
AND alc.lookup_type(+) 	   = 'NLS TRANSLATION'
AND alc.lookup_code(+)     = inv.approval_status
AND (ema.ecActionDataText2 = :P_EMAIL OR :P_EMAIL IS NULL)
AND to_timestamp_tz(ema.ecActionDataText1 ||' UTC', 'YYYY-MM-DD HH24:MI:SS TZR') >= :P_DATE_START
AND to_timestamp_tz(ema.ecActionDataText1 ||' UTC', 'YYYY-MM-DD HH24:MI:SS TZR') - interval '1' DAY < :P_DATE_END

ORDER BY ema.ecActionDataText1
