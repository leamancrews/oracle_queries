select period_name
from   gl_periods gp
where exists (select gl.period_set_name from gl_ledgers gl where gl.name = nvl(:P_GL_LEDGER, gl.name) and gl.period_set_name = gp.period_set_name)
order by gp.period_year, gp.period_num

select posted_date
from gl_je_headers gjh
where exists (select gjh.posted_date from gl_je_headers gjh where gjh.posted_date between nvl(:P_JE_START_DATE, gjh.posted_date) and nvl(:P_JE_STOP_DATE, gjh.posted_date))
order by gjh.posted_date