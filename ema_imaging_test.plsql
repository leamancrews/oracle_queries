SELECT  /*+ use_hash(inv) */
to_timestamp_tz(ema.ecActionDataText1
  ||' UTC', 'YYYY-MM-DD HH24:MI:SS TZR') AS "Mail Received",
  to_timestamp_tz(DECODE(ema.ecActionDataText5, NULL, NULL, ema.ecActionDataText5
  ||' UTC'), 'YYYY-MM-DD HH24:MI:SS TZR')                        AS "ODC",
ema.ecActionDataText2 AS "Received from Email" 

FROM
ecAudit ema

