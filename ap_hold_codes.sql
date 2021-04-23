SELECT *
  FROM AP_HOLD_CODES
 WHERE hold_lookup_code IN (SELECT hold_lookup_code
                              FROM AP_HOLDS_ALL
                             WHERE invoice_id = '1234567');