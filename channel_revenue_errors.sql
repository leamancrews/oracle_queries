SELECT led.name   ledger_name,
       oca.claim_number       "CLAIM_NUMBER/OFFER_CODE",
       NULL                   OFFER_NAME,
       ae.encoded_msg,
       xe.event_type_code,
       xe.event_status_code,
       xe.process_status_code,
       xte.entity_code,
       hro.name               OU_NAME,
       xte.transaction_number "UTILIZATION_ID/CLAIM_ID",
       xe.event_date,
       oca.creation_date      "CLAIM/accrual_date",
       oca.acctd_amount       Amount,
       oca.currency_code      Currency_code,
       xte.entity_code
  FROM XLA_EVENTS xe,
       XLA_ACCOUNTING_ERRORS ae,
       xla.XLA_TRANSACTION_ENTITIES xte,
       GL_LEDGERS led,
       HR_OPERATING_UNITS hro,
       OZF_CLAIMS_ALL oca
 WHERE ae.application_id = 682 
   AND led.ledger_id = xte.ledger_id 
   AND ae.event_id = xe.event_id 
   AND xte.entity_id = xe.entity_id 
   AND xte.ledger_id = ae.ledger_id 
   AND hro.organization_id(+) = xte.security_id_int_1 
   AND xte.entity_code = 'CLAIM_SETTLEMENT' 
   AND oca.claim_id = xte.source_id_int_1
UNION ALL
SELECT led.name               ledger_name,
       oz.name,
       oz.description         OFFER_NAME,
       ae.encoded_msg,
       xe.event_type_code,
       xe.event_status_code,
       xe.process_status_code,
       xte.entity_code,
       hro.name               OU_NAME,
       xte.transaction_number "UTILIZATION_ID/CLAIM_ID",
       xe.event_date,
       ou.creation_date       "CLAIM/accrual_date",
       ou.plan_curr_amount    Amount,
       ou.plan_currency_code  Currency_code,
       xte.entity_code
  FROM XLA_EVENTS xe,
       XLA_ACCOUNTING_ERRORS ae,
       xla.XLA_TRANSACTION_ENTITIES xte,
       GL_LEDGERS led,
       HR_OPERATING_UNITS hro,
       OZF_FUNDS_UTILIZED_ALL_B ou,
       OZF_OFFERS_V oz
 WHERE ae.application_id = 682 
   AND led.ledger_id = xte.ledger_id 
   AND ae.event_id = xe.event_id 
   AND xte.entity_id = xe.entity_id 
   AND xte.ledger_id = ae.ledger_id 
   AND hro.organization_id(+) = xte.security_id_int_1 
   AND ou.plan_id = oz.list_header_id 
   AND ou.utilization_id = xte.source_id_int_1 
   AND xte.entity_code = 'ACCRUAL';