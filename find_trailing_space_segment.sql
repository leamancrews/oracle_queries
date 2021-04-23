SELECT    
    t3.segment_identifier, 
    length(t3.segment_identifier), 
    t2.value_set_id, 
    t4.name, 
    length(t4.name), 
    t4.language, 
    replace(t4.name,' ','X') as mod_name
FROM
    fnd_kf_str_instances_b t1,
    fnd_kf_segment_instances t2,
    fnd_kf_segments_b t3,
    fnd_kf_segments_tl t4
WHERE
    t1.structure_instance_number = (select chart_of_accounts_id from 
    gl_ledgers where name = :ledger_name) AND
    t1.key_flexfield_code = 'GL#' AND
    t1.structure_instance_id = t2.structure_instance_id AND
    t2.display_flag = 'Y' AND
    t1.structure_id = t3.structure_id AND
    t2.segment_code=t3.segment_code AND
    t3.enabled_flag='Y' AND
    t3.segment_code = t4.segment_code
order by t4.language, t4.name
