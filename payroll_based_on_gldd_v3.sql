select gl.name ledger_name,
         gl.ledger_id,
         gb.period_name,
         gcc.code_combination_id,
         nvl(gb.BEGIN_BALANCE_DR,0) - nvl(gb.BEGIN_BALANCE_CR,0) per_beg_act_balance,
         (nvl(gb.BEGIN_BALANCE_DR,0) - nvl(gb.BEGIN_BALANCE_CR,0)) +  (nvl(gb.PERIOD_NET_DR,0) - nvl(gb. PERIOD_NET_CR,0)) per_end_act_balance,
         gcc.segment1 h_segment1,
         gcc.segment2 h_segment2,
         gcc.segment3 h_segment3,
         gcc.segment4 h_segment4,
         gcc.segment5 h_segment5,
         gcc.segment6 h_segment6,
         &ACCT account_desc
from   gl_balances gb,
          gl_ledgers gl,
          gl_code_combinations gcc,
          gl_periods gp
where gb.actual_flag = 'A'
and    gb.ledger_id = gl.ledger_id
and    gb.period_name = gp.period_name
and    gl.period_set_name = gp.period_set_name
and    gb.code_combination_id = gcc.code_combination_id
and    gl.name = :P_GL_LEDGER
and    gcc.segment2 IN (51105, 51110, 51115, 51205, 51210, 51215, 51305, 51310, 51315, 61105, 61110, 61205, 61210, 61215)
and    gp.start_date BETWEEN (SELECT start_date FROM gl_periods where period_name = :P_GL_PERIOD_START and period_set_name = gl.period_set_name and rownum <= 1) AND (SELECT start_date FROM gl_periods where period_name = :P_GL_PERIOD_END and period_set_name = gl.period_set_name and rownum <= 1)
order by gl.name, gcc.segment1, gcc.segment2,  gcc.segment3,  gcc.segment4, gb.period_year, gb.period_num