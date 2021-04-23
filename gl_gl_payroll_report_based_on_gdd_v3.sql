----------------------------------------------
-----No Link To SLA
----------------------------------------------
select gl.ledger_id
       , gl.name ledger_name
       , gjb.description gl_batch_description
       , gjh.posted_date
       , gjh.je_category
       , gjh.je_source
       , gjh.period_name gl_period_name
       , gjh.name journal_name
       , gjh.description journal_description
       , gjh.status
       , gjh.posted_date gl_posted_date
       , gjl.je_line_num
       , gjl.code_combination_id gl_code_combination_id
       , gjl.entered_dr gl_entered_dr
       , gjl.entered_cr gl_entered_cr
       , gjl.accounted_dr gl_accounted_dr
       , gjl.accounted_cr gl_accounted_cr
       , gjl.description journal_line_description
       , gjl.gl_sl_link_id
       , gjl.gl_sl_link_table
       , gcc.segment1
       , gcc.segment2
       , gcc.segment3
       , gcc.segment4
       , null -- xah.ae_header_id
       , null -- xah.application_id
       , null -- xah.entity_id
       , null -- xah.event_id
       , null -- xal.ae_line_num
       , null -- xal.gl_transfer_mode_code
       , null -- xal.accounting_class_code
       , null -- xte.entity_code
       , null -- xtel.source_id_int_1
       , null -- xdl.source_distribution_id_num_1
       , null -- xdl.source_distribution_type
       , 'GL' source
from  gl_je_headers gjh
       , gl_je_lines gjl
       , gl_je_batches gjb
       , gl_code_combinations gcc
       , gl_ledgers gl
       , gl_periods gp
where gjh.je_header_id = gjl.je_header_id
and	   gjh.je_category = 'Payroll'
and    gjl.gl_sl_link_id is null
and    gjl.gl_sl_link_table is null
and    gjh.je_batch_id = gjb.je_batch_id
and    gjl.code_combination_id = gcc.code_combination_id
and    gl.ledger_id = gjh.ledger_id
and    gjh.status = 'P' --Posted
--and    gjh.period_name IN (:P_GL_PERIOD)
and    gl.name = :P_GL_LEDGER
and    gjh.period_name = gp.period_name
-- and    gl.period_set_name = gp.period_set_name
-- and    gcc.segment1 between nvl(:P_GL_CC_SEGMENT1_LOW, gcc.segment1) and nvl(:P_GL_CC_SEGMENT1_HIGH, gcc.segment1)
-- and    gcc.segment2 between nvl(:P_GL_CC_SEGMENT2_LOW, gcc.segment2) and nvl(:P_GL_CC_SEGMENT2_HIGH, gcc.segment2)
-- and    gcc.segment3 between nvl(:P_GL_CC_SEGMENT3_LOW, gcc.segment3) and nvl(:P_GL_CC_SEGMENT3_HIGH, gcc.segment3)
-- and    gcc.segment4 between nvl(:P_GL_CC_SEGMENT4_LOW, gcc.segment4) and nvl(:P_GL_CC_SEGMENT4_HIGH, gcc.segment4)
-- and    gp.start_date BETWEEN (SELECT start_date FROM gl_periods where period_name = :P_GL_PERIOD_START and period_set_name = gl.period_set_name and rownum <= 1) AND (SELECT start_date FROM gl_periods where period_name = :P_GL_PERIOD_END and period_set_name = gl.period_set_name and rownum <= 1)
and    gjh.posted_date BETWEEN (SELECT posted_date FROM gl_je_headers where posted_date = :P_JE_START_DATE and rownum <= 1) AND (SELECT posted_date FROM gl_je_headers where posted_date = :P_JE_STOP_DATE and rownum <= 1)