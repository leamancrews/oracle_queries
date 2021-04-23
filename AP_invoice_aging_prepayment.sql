 SELECT vendor_name 
       , c_invoice_num 
       , invoice_date 
       , invoice_amount 
       , prepay_amount 
       , remaining_amount 
       , TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') as_of_date 
       , gl_date 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  < 31 
             THEN 
             remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 30 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  BETWEEN 
                  31 
                  AND 60 THEN remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 60 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  BETWEEN 
                  61 
                  AND 90 THEN remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 90 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  BETWEEN 
                  91 
                  AND 
                  120 THEN remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 120 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  BETWEEN 
                  121 AND 
                  150 THEN remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 150 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  BETWEEN 
                  151 AND 
                  180 THEN remaining_amount 
             ELSE NULL 
           END )                                       "DUE UPTO 180 DAYS" 
       , ( CASE 
             WHEN TO_DATE(SUBSTR(:p_date, 1, 10), 'YYYY/MM/DD') - TRUNC(gl_date) 
                  > 180 
             THEN 
             remaining_amount 
             ELSE NULL 
           END )                                       "DUE MORE THAN 180 DAYS" 
  FROM (SELECT   c_vendor_name                    vendor_name 
               , c_invoice_num 
               , invoice_date 
               , invoice_amount 
               , prepay_amount 
               , invoice_amount + prepay_amount remaining_amount 
               , gl_date 
          FROM (SELECT DISTINCT pv.vendor_name AS c_vendor_name 
                                , pvs.address_line1 AS c_address_line1 
                                , pvs.address_line2 AS c_address_line2 
                                , pvs.address_line3 AS c_address_line3 
                                , DECODE (pvs.city, '', '', 
                                                    pvs.city 
                                                    || ', ') 
                                  ||DECODE (pvs.state, '', '', 
                                                       pvs.state 
                                                       || ' ') 
                                  || pvs.zip AS c_city_state_zip 
                                , pvs.country AS c_country 
                                , inv.invoice_id 
								, inv.invoice_num AS c_invoice_num 
                                , inv.invoice_date 
                                  --pv.vendor_name, 
                                , aipp.last_update_date AS c_application_date 
                                , aipp.prepayment_amount_applied AS c_amount_applied 
                                , inv.invoice_currency_code AS c_currency_code 
                                , inv.gl_date 
                                , NVL (inv.invoice_amount, 0) AS invoice_amount 
                                , (SELECT SUM(amount) 
                                     FROM ap_invoice_distributions_all ida 
                                    WHERE line_type_lookup_code = 'PREPAY' 
                                      AND aid.invoice_distribution_id = ida.prepay_distribution_id) AS prepay_amount 
                  FROM   po_vendors pv 
                       , po_vendor_sites_all pvs 
                       , ap_invoices_all inv 
                       , ap_invoice_distributions_all aid 
                       , ap_invoice_prepays_all aipp 
                 WHERE pv.vendor_id = pvs.vendor_id 
                   AND pv.vendor_id = inv.vendor_id 
                   AND pvs.vendor_site_id = inv.vendor_site_id 
                   AND inv.invoice_id = aid.invoice_id 
                   AND aipp.invoice_id(+) = inv.invoice_id 
                   AND pv.vendor_id = NVL(:p_vendor_id, pv.vendor_id) 
                   AND NVL (pvs.LANGUAGE, 'AMERICAN') = 'AMERICAN' 
                   AND aid.line_type_lookup_code <> 'PREPAY' 
                   --AND inv.invoice_num = 'Adv/Po#6204,7405,6924' 
               ) 
         WHERE invoice_amount - prepay_amount IS NOT NULL) 
 WHERE remaining_amount > 0