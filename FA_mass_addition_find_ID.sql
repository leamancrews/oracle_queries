select mass_addition_id, amortization_start_date
from fa_mass_additions
where book_type_code = '&book' 
and posting_status = 'POST'; 
