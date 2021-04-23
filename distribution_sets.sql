SELECT 
		dsall.DISTRIBUTION_SET_ID "ID"
		,dsall.DISTRIBUTION_SET_NAME "Name"
		,dsall.DESCRIPTION "Description"
		,orgu.name "BU"
		,dslall.PERCENT_DISTRIBUTION "Percentage"
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 "Code"
        ,CASE 
        WHEN dsall.INACTIVE_DATE IS NOT NULL THEN 'No'
        WHEN dsall.INACTIVE_DATE IS NULL THEN 'Yes'
        END AS "Enabled"
		

FROM 
		AP_DISTRIBUTION_SETS_ALL dsall
		,AP_DISTRIBUTION_SET_LINES_ALL dslall
		,HR_ORGANIZATION_UNITS_F_TL orgu
		,gl_code_combinations gcc
		
WHERE 1=1
  AND dsall.DISTRIBUTION_SET_ID = dslall.DISTRIBUTION_SET_ID
  AND dslall.DIST_CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID
  AND dsall.ORG_ID = orgu.organization_id