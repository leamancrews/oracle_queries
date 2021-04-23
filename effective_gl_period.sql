SELECT DISTINCT
 xlo.effective_period_num xlo_effective_period_num ,
 (
   SELECT
     MAX(gps.effective_period_num)
   FROM
     gl_period_statuses gps
   WHERE
     gps.application_id           = 101
   AND gps.ledger_id              = xlo.ledger_id
   AND gps.closing_status        IN ('O','C','P')
   AND gps.adjustment_period_flag = 'N'
 )
 gps_effective_period_num ,
 xlo.ledger_id
FROM
 xla_ledger_options xlo ,
 xla_ledger_relationships_v xlr ,
 xla_ae_headers xah
WHERE
 xlo.ledger_id = DECODE(xlr.ledger_category_code , 'ALC' ,
 xlr.primary_ledger_id, xlr.ledger_id)
AND xlo.application_id = 200
AND xah.application_id = 200
AND xlr.ledger_id      = xah.ledger_id;