select

	p.PARTY_NAME,
	ca.ACCOUNT_NUMBER,
	ca.ATTRIBUTE2 "LOCATION_TYPE",
	loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code "ZIP_CODE",
	csu.SITE_USE_CODE,
	ca.CUST_ACCOUNT_ID "OCAID"

from 

	hz_cust_accounts CA,
	hz_parties P,
	hz_locations LOC,
	hz_cust_site_uses_all CSU,
	hz_cust_acct_sites_all CAS,
	hz_party_sites PS

where
 
	1=1
	and ca.PARTY_ID=p.PARTY_ID
	and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
	and cas.PARTY_SITE_ID=ps.party_site_id
	and ps.location_id=loc.LOCATION_ID