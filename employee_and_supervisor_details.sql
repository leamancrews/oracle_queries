SELECT fu.user_name, 
       per.full_name,
       per.employee_number,
       per1.full_name supervisor_name,
       per1.employee_number supervisor_number,
       gcc.concatenated_segments Supervisor_default_expense_account
  FROM fnd_user fu, 
       per_all_people_f per ,
       per_all_assignments_f pf ,
       per_all_people_f per1,
       per_all_assignments_f pf1,
       gl_code_combinations_kfv gcc
 WHERE fu.employee_id = per.person_id 
   AND SYSDATE BETWEEN per.effective_start_date AND per.effective_end_date
   AND SYSDATE BETWEEN pf.effective_start_date AND pf.effective_end_date
   AND pf.person_id = per.person_id 
   AND pf.supervisor_id = per1.person_id
   AND per1.person_id = pf1.person_id
   AND SYSDATE BETWEEN per1.effective_start_date AND per1.effective_end_date
   AND SYSDATE BETWEEN pf1.effective_start_date AND pf1.effective_end_date 
   AND pf1.default_code_comb_id = gcc.code_combination_id