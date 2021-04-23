SELECT
			hp.party_name, 
			hca.account_number,
			hca.ATTRIBUTE2 "LOCATION_TYPE",
			loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code "ZIP_CODE",
			hcsu.SITE_USE_CODE
							
FROM 
			hz_parties hp,
            hz_cust_accounts hca,
            hz_locations loc,
            hz_cust_acct_sites_all hcas,
            hz_cust_site_uses_all hcsu,
            hz_party_sites ps
                
WHERE 

			1=1
            AND hp.party_id = hca.party_id
            AND hca.cust_account_id = hcas.cust_account_id
            AND hcas.cust_acct_site_id = hcsu.cust_acct_site_id
            AND hcas.party_site_id=ps.party_site_id
        	AND ps.location_id=loc.LOCATION_ID
            