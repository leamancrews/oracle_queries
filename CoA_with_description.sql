SELECT gl_flexfields_pkg.get_concat_description
                                          (chart_of_accounts_id,
                                           code_combination_id
                                          ) "Account",
            segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5 "Code"
            FROM gl_code_combinations