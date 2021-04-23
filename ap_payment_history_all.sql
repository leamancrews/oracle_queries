SELECT
  payment_history_id,
  check_id,
  accounting_date,
  SUBSTR (transaction_type, 1, 20  transaction_type,
  posted_flag,
  SUBSTR (accounting_event_id, 1, 10) accounting_event_id,
  rev_pmt_hist_id,
  org_id
FROM    AP_PAYMENT_HISTORY_ALL
WHERE check_id IN
      (SELECT DISTINCT check_id
       FROM AP_INVOICE_PAYMENTS_ALL
       WHERE invoice_id = '124567'
      )
ORDER BY payment_history_id; 