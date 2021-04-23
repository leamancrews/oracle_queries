SELECT aps.SEGMENT1 AS SUPPLIER_NUM,
      aps.VENDOR_NAME,
      ac.ORG_ID,
      SITE.VENDOR_SITE_CODE, SITE.ADDRESS1, SITE.address2, SITE.CITY, SITE.STATE, SITE.POSTAL_CODE,   
      SITE.LOCATION_ID,
      sum(ac.AMOUNT) AS TOTAL_PAYMENTS
FROM poz_suppliers_v aps,
     ap_checks_all ac,
-----------------------------
    (SELECT VENDOR_SITE_ID, VENDOR_ID, SUPPLIER_NUM, VENDOR_SITE_CODE, TOTAL_AMOUNT, ADDRESS1, address2, CITY, STATE, POSTAL_CODE, LOCATION_ID
              FROM  (select s.VENDOR_SITE_ID,
                            v.vendor_id,
                            v.segment1  SUPPLIER_NUM,
                            s.vendor_site_code,
                            loc.address1,
                            loc.address2,
                            loc.city,
                            loc.state,
                            loc.postal_code,
                            s.location_id,
                            SUM(c.amount) TOTAL_AMOUNT
                    from poz_suppliers_v v,
                          poz_supplier_sites_all_m s,
                          hz_locations loc,
                          ap_checks_all c
                    where v.vendor_id = s.vendor_id
                      and s.location_id = loc.location_id(+)
                      and c.vendor_site_id = s.vendor_site_id
                      and c.check_date >= sysdate -365
                      and c.status_lookup_code <> 'VOIDED'
                    group by s.VENDOR_SITE_ID, v.vendor_id, v.segment1, rownum, s.vendor_site_code, loc.address1, loc.address2,
                             loc.city, loc.state, loc.postal_code,    s.location_id)
    ) SITE
-----------------------------------
WHERE ac.VENDOR_ID = aps.VENDOR_ID
  AND ac.CHECK_DATE >= sysdate -365
  AND ac.STATUS_LOOKUP_CODE <> 'VOIDED'
  AND aps.VENDOR_ID = SITE.VENDOR_ID(+)
GROUP BY ac.ORG_ID, aps.SEGMENT1, aps.VENDOR_NAME,
         SITE.VENDOR_SITE_CODE, SITE.ADDRESS1, SITE.address2, SITE.CITY, SITE.STATE, SITE.POSTAL_CODE, 
           SITE.LOCATION_ID
ORDER BY ORG_ID, VENDOR_NAME, SUPPLIER_NUM, VENDOR_SITE_CODE
