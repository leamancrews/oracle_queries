SELECT   u.username user_name, a.display_name emp_name, c.bu_name,
         d.NAME le_name

    FROM per_users u,
         per_person_names_f a,
         per_all_assignments_f b,
         fun_all_business_units_v c,
         xle_entity_profiles d

   WHERE 1 = 1
     AND u.person_id = a.person_id
     AND a.person_id = b.person_id
     AND b.business_unit_id = c.bu_id
     AND c.legal_entity_id = d.legal_entity_id
     AND TRUNC (SYSDATE) BETWEEN TRUNC (a.effective_start_date)
                             AND TRUNC (a.effective_end_date)
     AND TRUNC (SYSDATE) BETWEEN TRUNC (b.effective_start_date)
                             AND TRUNC (b.effective_end_date)
     AND a.name_type = 'GLOBAL'
     AND b.primary_assignment_flag = 'Y'

ORDER BY u.username

