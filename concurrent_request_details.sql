SELECT   fe.executable_name,
         DECODE (fe.execution_method_code,
                 'I', 'PLSQL Stored Procedure',
                 'P', 'Report',
                 'L', 'SQL Loader',
                 'Q', 'SQL*Plus',
                 fe.execution_method_code
                ) "execution method",
         fe.execution_file_name, 'NULL',
         faex.application_name executable_application,
         fcpl.user_concurrent_program_name "Concurrent Program",
         fcp.concurrent_program_name "CONC SHORT NAME",
         fav.application_name "CONC PROG APPL", fcp.output_file_type,
         fdfcuv.end_user_column_name parameter,
         ffvs.flex_value_set_name "Value Set",
         DECODE (fdfcuv.default_type,
                 'C', 'Constant',
                 'P', 'Profile',
                 'S', 'SQL Statement',
                 'A', 'Segment',
                 fdfcuv.default_type
                ) default_type,
         fdfcuv.DEFAULT_VALUE, frg.request_group_name "Request Group",
         frg.description "Request group desc", rsp_vl.responsibility_name
    FROM fnd_concurrent_programs fcp,
         fnd_concurrent_programs_tl fcpl,
         fnd_descr_flex_col_usage_vl fdfcuv,
         fnd_application_vl fav,
         fnd_application_vl faex,
         fnd_flex_value_sets ffvs,
         fnd_executables fe,
         fnd_request_groups frg,
         fnd_request_group_units frgu,
         fnd_responsibility_vl rsp_vl
   WHERE fcp.concurrent_program_id = fcpl.concurrent_program_id
     AND UPPER (fcpl.user_concurrent_program_name) = UPPER ('XAOA Test Concurrent Program')
     AND fav.application_id = fcp.application_id
     AND fcpl.LANGUAGE = 'US'
     AND ffvs.flex_value_set_id = fdfcuv.flex_value_set_id
     AND fdfcuv.descriptive_flexfield_name =
                                       '$SRS$.' || fcp.concurrent_program_name
     AND fdfcuv.enabled_flag = 'Y'
     AND fcp.executable_id = fe.executable_id
     AND faex.application_id = fe.application_id
     AND frg.request_group_id = frgu.request_group_id
     AND frgu.request_unit_id(+) = fcp.concurrent_program_id
     AND frgu.request_group_id = rsp_vl.request_group_id
ORDER BY fdfcuv.column_seq_num ASC;