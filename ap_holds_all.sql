SELECT held_by,
       hold_date,
       hold_lookup_code,
       SUBSTR (hold_reason, 1, 25) hold_reason,
       invoice_id,
       release_lookup_code,
       SUBSTR (release_reason, 1, 25) release_reason,
       status_flag,
       org_id
  FROM AP_HOLDS_ALL
 WHERE invoice_id = '1234567';