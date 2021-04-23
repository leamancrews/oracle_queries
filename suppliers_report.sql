select

	suppliers.SEGMENT1 "SUPPLIER_NUMBER",
	parties.PARTY_NAME "VENDOR_NAME",
	parties.PRIMARY_PHONE_AREA_CODE||'.'||parties.PRIMARY_PHONE_NUMBER "PRIMARY_PHONE",
	parties.EMAIL_ADDRESS,
	parties.ADDRESS1,
	parties.ADDRESS2,
	parties.CITY,
	parties.STATE,
	parties.POSTAL_CODE,	
	suppliers.LAST_UPDATED_BY,
	suppliers.LAST_UPDATE_DATE,
	
	CASE 
        WHEN suppliers.END_DATE_ACTIVE IS NOT NULL THEN 'No'
        WHEN suppliers.END_DATE_ACTIVE IS NULL THEN 'Yes'
        END AS "ACTIVE",
        
    suppliers.END_DATE_ACTIVE "INACTIVATED_DATE",
    suppliers.VENDOR_TYPE_LOOKUP_CODE "VENDOR_TYPE",
    suppliers.ONE_TIME_FLAG "ONE_TIME_VENDOR",
    suppliers.ORGANIZATION_TYPE_LOOKUP_CODE "ORGANIZATION_TYPE",
    suppliers.BUSINESS_RELATIONSHIP,
    suppliers.FEDERAL_REPORTABLE_FLAG "FEDERAL_REPORTABLE",
    suppliers.TYPE_1099 "1099_TYPE"
    
from 
	POZ_SUPPLIERS suppliers,
	HZ_PARTIES parties
	
where
	1=1	
	AND suppliers.PARTY_ID = parties.PARTY_ID
	