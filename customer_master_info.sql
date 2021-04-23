select p.PARTY_NAME,ca.ACCOUNT_NUMBER,loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code,
loc.country,ca.CUST_ACCOUNT_ID
from apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
where I.COMPLETE_FLAG =’Y’
and I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
and ca.PARTY_ID=p.PARTY_ID
and I.bill_to_site_use_id=csu.site_use_id
and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
and cas.PARTY_SITE_ID=ps.party_site_id
and ps.location_id=loc.LOCATION_ID