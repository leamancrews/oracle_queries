SELECT papf.person_number, ppnf.full_name person_name, pg_old.NAME old_grade,
       pg_new.NAME new_grade,
       TO_CHAR (paaf_new.effective_start_date, 'DD-Mon-YYYY') new_start_Date,
       TO_CHAR (paaf_new.effective_end_date, 'DD-Mon-YYYY') new_end_date,
       TO_CHAR (paaf_old.effective_start_date, 'DD-Mon-YYYY') old_start_date,
       TO_CHAR (paaf_old.effective_end_date, 'DD-Mon-YYYY') old_end_date
 
FROM per_all_people_f papf,
       per_all_assignments_f paaf_old,
       per_grades pg_old,
       per_all_assignments_f paaf_new,
       per_grades pg_new,
       per_person_names_f ppnf
 
WHERE 1 = 1
 
   AND papf.person_id = paaf_old.person_id
   AND papf.person_id = ppnf.person_id
   AND papf.person_id = paaf_new.person_id
   AND paaf_old.person_id = paaf_new.person_id
   AND paaf_old.primary_flag = 'Y'
   AND paaf_new.assignment_type = 'E'
   AND paaf_new.primary_flag = 'Y'
   AND pg_old.grade_id = paaf_old.grade_id
   AND pg_new.grade_id = paaf_new.grade_id
   ---AND papf.person_number = '18375'
   AND ppnf.name_type = 'GLOBAL'
   AND ppnf.legislation_code = 'NG'
   AND paaf_old.grade_id <> paaf_new.grade_id
   -----AND TRUNC (paaf_old.effective_end_date) + 1 =
   and TRUNC (paaf_new.effective_start_date) -1 between paaf_old.effective_start_date and paaf_old.effective_end_date
   AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
   AND papf.effective_end_date
   AND TRUNC (SYSDATE) BETWEEN ppnf.effective_start_date
   AND ppnf.effective_end_date
   AND paaf_new.effective_start_date BETWEEN ppnf.effective_start_date
   AND ppnf.effective_end_date
   AND TRUNC (SYSDATE) BETWEEN trunc(paaf_new.effective_start_date) AND trunc (paaf_new.effective_end_date)
   AND extract (year from paaf_new.effective_start_date) = '2019'
 
 
ORDER BY papf.person_number
