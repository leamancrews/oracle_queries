SELECT

invoice_num, invoice_date, party_name, amount_paid, ap_invoices_all.description,
LOWER(ap_invoices_all.created_by) as CREATED_BY,
AP_INV_APRVL_HIST_ALL.LAST_UPDATE_DATE as APPROVAL_DATE,
LOWER(AP_INV_APRVL_HIST_ALL.approver_id) as APPROVER_ID

FROM 

AP_INV_APRVL_HIST_ALL, ap_invoices_all, hz_parties

WHERE 1=1 

and AP_INV_APRVL_HIST_ALL.invoice_id = ap_invoices_all.invoice_id
and ap_invoices_all.party_id = hz_parties.party_id
and AP_INV_APRVL_HIST_ALL.response = 'APPROVED'

ORDER BY AP_INV_APRVL_HIST_ALL.LAST_UPDATE_DATE desc



/* and LOWER(ap_invoices_all.created_by) = NVL(:P_CREATOR, LOWER(ap_invoices_all.created_by))
and LOWER(AP_INV_APRVL_HIST_ALL.approver_id) = NVL(:P_APPROVER, LOWER(AP_INV_APRVL_HIST_ALL.approver_id)) */
