SELECT line_number,
       line_type_lookup_code,
       line_source,
       accounting_date,
       period_name,
       deferred_acctg_flag,
       org_id
  FROM AP_INVOICE_LINES_ALL
 WHERE invoice_id = '1234567';