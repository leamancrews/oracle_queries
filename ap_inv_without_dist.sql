SELECT ap_invoices_pkg.get_posting_status(ai.invoice_id) posting_flag
,AI.*
FROM AP_INVOICES_ALL AI
WHERE AI.SET_OF_BOOKS_ID = <&ledger_id>
AND AI.GL_DATE BETWEEN to_date('<&yyyy-mm-dd>', 'YYYY-MM-DD') and
to_date('<&yyyy-mm-dd>', 'YYYY-MM-DD')
AND ap_invoices_pkg.get_posting_status(ai.invoice_id) != 'Y';

