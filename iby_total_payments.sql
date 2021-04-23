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
        sum(IBYP.PAYMENT_AMOUNT) AS TOTAL_PAYMENTS,
        COUNT(IBYP.PAYMENT_AMOUNT) AS NUMBER_PAYMENTS,
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
        IBY_PAYMENTS_ALL IBYP
 
where 1=1   
        AND PVS.VENDOR_ID = PS.VENDOR_ID 
        AND HZL.LOCATION_ID = PVS.LOCATION_ID
        AND HPS.PARTY_SITE_ID = PVS.PARTY_SITE_ID 
        AND PVS.PARTY_SITE_ID = IEPA.PARTY_SITE_ID
        AND IEPA.PARTY_SITE_ID = IBYP.PARTY_SITE_ID
        AND IEPA.EXT_PAYEE_ID = IEPPM.EXT_PMT_PARTY_ID 
        AND PVS.TERMS_ID = APT.TERM_ID           
        AND PVS.INACTIVE_DATE IS NULL 
        AND PVS.PAY_SITE_FLAG = 'Y'

group by HZL.LOCATION_ID,
	PS.SEGMENT1,
        rownum,
	PS.VENDOR_NAME,
        PVS.VENDOR_SITE_CODE,
        PVS.PAY_GROUP_LOOKUP_CODE,
        HZL.ADDRESS1,
        HZL.ADDRESS2,
        HZL.CITY,
        HZL.STATE,
        HZL.POSTAL_CODE,
        IBYP.PAYMENT_AMOUNT,
        APT.NAME,
        IEPPM.PAYMENT_METHOD_CODE

order by SUPPLIER_NUMBER, LOCATION_ID
