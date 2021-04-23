SELECT led.name ledger_name,
       ae.encoded_msg,
       xe.event_type_code,
       xe.event_status_code,
       xe.process_status_code,
       xte.entity_code,
       hro.name  ORG_NAME,
       xte.transaction_number ,
       xe.event_date,
       xte.entity_code,
       xte.source_id_int_1
  FROM xla_events xe,
       xla_accounting_errors ae,
       xla.xla_transaction_entities xte,
       gl_ledgers led,
       hr_all_organization_units hro
 WHERE ae.application_id = 707 
   AND led.ledger_id = xte.ledger_id 
   AND ae.event_id = xe.event_id 
   AND xte.entity_id = xe.entity_id 
   AND xte.ledger_id = ae.ledger_id 
   AND hro.organization_id(+) = xte.security_id_int_1 ;