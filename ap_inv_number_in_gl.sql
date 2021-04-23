SELECT
       TO_CHAR (inv.invoice_num) trx_num, inv.invoice_date trx_date,
       glp.start_date, gjh.je_header_id, gjh.doc_sequence_value voucher_no,
       gjh.je_source, gjh.je_category, entity_code, gjh.period_name,
       gjh.status, gjh.actual_flag, gjh.default_effective_date,
       gjl.je_line_num,
       xal.accounted_dr debit, xal.accounted_cr credit
    
     FROM gl_je_headers gjh,
       gl_je_lines gjl,
       gl_code_combinations gcc,
       gl_periods glp,
       gl_import_references imp,
       xla_ae_lines xal,
       xla_ae_headers xah,
       xla_events xe,
       xla_transaction_entities xte,
       ap_invoices_all inv

WHERE 1 = 1
   AND gjh.je_header_id = gjl.je_header_id
   AND gjl.status || '' = 'P'
   AND gjl.code_combination_id = gcc.code_combination_id
   AND gjh.period_name = glp.period_name
   AND glp.adjustment_period_flag <> 'Y'
   AND gjh.je_source = 'Payables'
   AND gjl.je_header_id = imp.je_header_id
   AND gjl.je_line_num = imp.je_line_num
   AND imp.gl_sl_link_id = xal.gl_sl_link_id
   AND imp.gl_sl_link_table = xal.gl_sl_link_table
   AND xal.application_id = xah.application_id
   AND xal.ae_header_id = xah.ae_header_id
   AND xah.application_id = xe.application_id
   AND xah.event_id = xe.event_id
   AND xe.application_id = xte.application_id
   AND xte.application_id = 200
   AND xe.entity_id = xte.entity_id
   AND xte.entity_code = 'AP_INVOICES'
   AND xte.source_id_int_1 = inv.invoice_id

