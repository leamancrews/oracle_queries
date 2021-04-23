SELECT
  check_id,
  check_number,
  vendor_site_code,
  Amount,
  base_amount,
  checkrun_id,
  checkrun_name,
  check_date,
  SUBSTR (status_lookup_code, 1, 15) status_lookup_code,
  void_date,
  org_id
FROM    AP_CHECKS_ALL
WHERE check_id IN
      (SELECT DISTINCT check_id
        FROM   AP_INVOICE_PAYMENTS_ALL
        WHERE invoice_id = '124567'
      ); 