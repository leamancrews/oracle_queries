SELECT ai.invoice_id,
         SUBSTR (aps.vendor_name, 1, 25) vendor_name,
         SUBSTR (ai.invoice_num, 1, 25) invoice_num,
         ai.invoice_date,
         ai.invoice_amount,
         ai.base_amount,
         SUBSTR (ai.invoice_type_lookup_code, 1, 15) invoice_type_lookup_code,
         SUBSTR (ai.invoice_currency_code, 1, 3) invoice_currency_code,
         SUBSTR (ai.payment_currency_code, 1, 3) payment_currency_code,
         ai.legal_entity_id,
         ai.org_id
    FROM AP_INVOICES_ALL ai, AP_SUPPLIERS aps, AP_SUPPLIER_SITES_ALL avs
   WHERE     ai.invoice_id = '1234567'
         AND ai.vendor_id = aps.vendor_id(+)
         AND ai.vendor_site_id = avs.vendor_site_id(+)
ORDER BY ai.invoice_id;