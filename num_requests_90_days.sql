select trunc(PROCESSSTART), count(*)
from   request_history
where trunc(PROCESSSTART) > trunc(PROCESSSTART ) - 90
group by trunc(PROCESSSTART)