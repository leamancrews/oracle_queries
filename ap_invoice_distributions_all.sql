SELECT invoice_id,
         invoice_line_number,
         SUBSTR (distribution_line_number, 1, 8) distribution_line_number,
         SUBSTR (line_type_lookup_code, 1, 9) line_type_lookup_code,
         accounting_date,
         period_name,
         Amount,
         base_amount,
         posted_flag,
         match_status_flag,
         encumbered_flag,
         SUBSTR (dist_code_combination_id, 1, 15) dist_code_combination_id,
         SUBSTR (accounting_event_id, 1, 15) accounting_event_id,
         SUBSTR (bc_event_id, 1, 15) bc_event_id,
         SUBSTR (invoice_distribution_id, 1, 15) invoice_distribution_id,
         SUBSTR (parent_reversal_id, 1, 15) parent_reversal_id,
         SUBSTR (po_distribution_id, 1, 15) po_distribution_id,
         org_id
    FROM AP_INVOICE_DISTRIBUTIONS_ALL
   WHERE invoice_id = '1234567'
ORDER BY invoice_line_number,
         invoice_distribution_id,
         distribution_line_number;
