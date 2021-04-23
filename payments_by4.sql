SELECT
        api.vendor_id "Invoice Vendor ID", 
        pvi.vendor_name "Invoice Vendor Name",
        api.invoice_type_lookup_code "Inv Type",
        pvsi.location_id,
        aic.payment_method_lookup_code "Payment method",
        aic.payment_type_flag "Payment Type",     
        sum(aip.amount) "Payment Amount",
        count(aip.amount) "No of Payments"

FROM 
    ap_invoices_all api
    , poz_suppliers_v pvi
    , poz_supplier_sites_all_m pvsi
    , ap_invoice_payments_all aip
    , ap_checks_all aic

WHERE 1 = 1
    AND aic.status_lookup_code <> 'VOIDED' 
    AND aic.check_id(+) = aip.check_id
    AND aip.invoice_id(+) = api.invoice_id
    AND pvsi.location_id = aic.vendor_site_id
    AND pvi.vendor_id = aic.vendor_id
    AND api.payment_status_flag = 'Y'
    AND aic.creation_date >= sysdate -375
    AND aic.payment_type_flag != 'Q'

GROUP BY api.vendor_id, pvi.vendor_name, api.invoice_type_lookup_code, pvsi.location_id, aic.payment_type_flag, aic.payment_method_lookup_code

ORDER BY pvi.vendor_name, pvsi.location_id, api.invoice_type_lookup_code,  aic.payment_type_flag, aic.payment_method_lookup_code
