SELECT aps.SEGMENT1 AS SUPPLIER_NUM,
      aps.VENDOR_NAME,
      ac.ORG_ID,
      SITE.VENDOR_SITE_CODE, SITE.ADDRESS_LINE1, SITE.ADDRESS_LINE2, SITE.CITY, SITE.STATE, SITE.ZIP, SITE.COUNTRY, SITE.AREA_CODE, SITE.PHONE,
      SITE.LOCATION_ID,
      sum(ac.AMOUNT) AS TOTAL_PAYMENTS
FROM ap_suppliers aps,
     ap_checks_all ac,
-----------------------------
    (SELECT SITE_ORG_ID, VENDOR_ID, SUPPLIER_NUM, VENDOR_SITE_CODE, SITE_RANK, TOTAL_AMOUNT, ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, ZIP, COUNTRY, AREA_CODE, PHONE, LOCATION_ID
              FROM  (select s.org_id SITE_ORG_ID,
                            v.vendor_id,
                            v.segment1  SUPPLIER_NUM,
                            s.vendor_site_code,
                            s.address_line1,
                            s.address_line2,
                            s.city,
                            s.state,
                            s.zip,
                            loc.country,
                            s.area_code,
                            s.phone,
                            s.org_id,
                            s.location_id,
                            DENSE_RANK() OVER (PARTITION BY s.ORG_ID, v.SEGMENT1 ORDER BY rownum, sum(c.AMOUNT) DESC) AS SITE_RANK,
                            SUM(c.amount) TOTAL_AMOUNT
                    from ap_suppliers v,
                          ap_supplier_sites_all s,
                          hz_locations loc,
                          ap_checks_all c
                    where v.vendor_id = s.vendor_id
                      and s.location_id = loc.location_id(+)
                      and c.vendor_site_id = s.vendor_site_id
                      and TRUNC(c.check_date) BETWEEN '01-JAN-2018' AND '31-MAR-2018'
                      and c.status_lookup_code <> 'VOIDED'
                      and s.org_id = 456
                    group by s.org_id, v.vendor_id, v.segment1, rownum, s.vendor_site_code, s.address_line1, s.address_line2,
                             s.city, s.state, s.zip, loc.country, s.area_code, s.phone, s.location_id)
    WHERE SITE_RANK = 1) SITE
-----------------------------------
WHERE ac.VENDOR_ID = aps.VENDOR_ID
  AND TRUNC(ac.CHECK_DATE) BETWEEN '01-JAN-2018' AND '31-MAR-2018'
  AND ac.STATUS_LOOKUP_CODE <> 'VOIDED'
  AND ac.ORG_ID = 456
  AND aps.VENDOR_ID = SITE.VENDOR_ID(+)
----  AND aps.SEGMENT1 IN ('66920')
GROUP BY ac.ORG_ID, aps.SEGMENT1, aps.VENDOR_NAME,
         SITE.VENDOR_SITE_CODE, SITE.ADDRESS_LINE1, SITE.ADDRESS_LINE2, SITE.CITY, SITE.STATE, SITE.ZIP, SITE.COUNTRY,
         SITE.AREA_CODE, SITE.PHONE, SITE.LOCATION_ID
ORDER BY ORG_ID, VENDOR_NAME, SUPPLIER_NUM, VENDOR_SITE_CODE

select
distinct HZL.LOCATION_ID,
	PS.SEGMENT1 SUPPLIER_NUMBER,
	PS.VENDOR_NAME SUPPLIER_NAME,
        PVS.VENDOR_SITE_CODE SUPPLIER_SITE,
        PVS.PAY_GROUP_LOOKUP_CODE PAY_GROUP,
        HZL.ADDRESS1,
        HZL.ADDRESS2,
        HZL.CITY,
        HZL.STATE,
        HZL.POSTAL_CODE,
        sum(APCA.AMOUNT) AS TOTAL_PAYMENTS,
        APT.NAME "PAYMENT TERMS",
        IEPPM.PAYMENT_METHOD_CODE "PAYMENT METHOD"

from 
        POZ_SUPPLIERS_V PS,
        POZ_SUPPLIER_SITES_ALL_M PVS,
        HZ_LOCATIONS HZL,
        AP_TERMS_TL APT,
        HZ_PARTY_SITES HPS,
        IBY_EXTERNAL_PAYEES_ALL IEPA,
        IBY_EXT_PARTY_PMT_MTHDS IEPPM,
        AP_CHECKS_ALL APCA
 
where 1=1   
        AND HZL.LOCATION_ID = PVS.LOCATION_ID(+)
       AND HPS.PARTY_SITE_ID = PVS.PARTY_SITE_ID(+) 
      AND IEPA.PARTY_SITE_ID = PVS.PARTY_SITE_ID
        AND PVS.PARTY_SITE_ID = APCA.PARTY_SITE_ID
        AND PVS.VENDOR_ID = PS.VENDOR_ID 
        AND PVS.TERMS_ID = APT.TERM_ID           
        AND IEPA.EXT_PAYEE_ID = IEPPM.EXT_PMT_PARTY_ID 
        AND PVS.INACTIVE_DATE IS NULL 
        AND PVS.PAY_SITE_FLAG = 'Y'
        AND APCA.CHECK_DATE >= sysdate -365
        AND APCA.STATUS_LOOKUP_CODE <> 'VOIDED'

group by HZL.LOCATION_ID, PS.SEGMENT1, IEPPM.PAYMENT_METHOD_CODE, PS.VENDOR_NAME, PVS.VENDOR_SITE_CODE, HZL.ADDRESS1, HZL.ADDRESS2, HZL.CITY, HZL.STATE, HZL.POSTAL_CODE, APT.NAME,  APCA.AMOUNT,  PVS.PAY_GROUP_LOOKUP_CODE

order by SUPPLIER_NUMBER, LOCATION_ID

select 
    distinct HZL.LOCATION_ID,
    PS.SEGMENT1 SUPPLIER_NUMBER,
    PS.VENDOR_NAME SUPPLIER_NAME,
    PVS.VENDOR_SITE_CODE SUPPLIER_SITE,
    count(APIA.INVOICE_ID) AS INVOICE_COUNT

from 
    POZ_SUPPLIER_SITES_ALL_M PVS,
    HZ_LOCATIONS HZL,
    HZ_PARTY_SITES HPS,
    AP_INVOICES_ALL APIA,
    POZ_SUPPLIERS_V PS,

where
     AND HZL.LOCATION_ID = PVS.LOCATION_ID(+)
     AND HPS.PARTY_SITE_ID = PVS.PARTY_SITE_ID(+) 
     AND PVS.PARTY_SITE_ID = APIA.PARTY_SITE_ID
     AND PVS.VENDOR_ID = PS.VENDOR_ID 

group by PS.SEGMENT1, HZL.LOCATION_ID, PS.VENDOR_NAME, PVS.VENDOR_SITE_CODE, APIA.INVOICE_ID

order by SUPPLIER_NUMBER, LOCATION_ID     













select 
                            distinct s.location_id,
                            s.party_site_id,
                            v.vendor_id,
                            v.segment1  SUPPLIER_NUM,
                            s.vendor_site_code,
                            loc.address1,
                            loc.address2,
                            loc.city,
                            loc.state,
                            loc.postal_code,
                            loc.country,
                            SUM(c.amount) TOTAL_AMOUNT,
                            apt.NAME PAYMENT_TERMS

                    from POZ_SUPPLIERS_V  v,
                         POZ_SUPPLIER_SITES_ALL_M s,
                          hz_locations loc,
                          ap_checks_all c,
                          ap_terms_tl apt

                    where v.vendor_id = s.vendor_id(+)
                      and s.location_id = loc.location_id(+)
                      and s.vendor_site_id = c.vendor_site_id
                      and s.terms_id = apt.term_id
                      and c.check_date >= sysdate -365
                      and c.status_lookup_code <> 'VOIDED'

group by s.party_site_id, v.vendor_id, v.segment1, rownum, s.vendor_site_code, loc.address1, loc.address2, loc.city, loc.state, loc.postal_code, loc.country, s.location_id, apt.NAME

order by SUPPLIER_NUM
