SELECT led.name ledger_name,
       ae.encoded_msg,
       xe.event_type_code,
       xe.event_status_code,
       xe.process_status_code,
       xte.entity_code,
       hro.name OU_NAME,
       xte.transaction_number ,
       xe.event_date,
       xte.entity_code,
       xte.source_id_int_1
  FROM XLA_EVENTS xe,
       XLA_ACCOUNTING_ERRORS ae,
       xla.XLA_TRANSACTION_ENTITIES xte,
       GL_LEDGERS led,
       HR_OPERATING_UNITS hro
 WHERE ae.application_id = 140 
   AND led.ledger_id = xte.ledger_id 
   AND ae.event_id = xe.event_id 
   AND xte.entity_id = xe.entity_id 
   AND xte.ledger_id = ae.ledger_id 
   AND hro.organization_id(+) = xte.security_id_int_1;