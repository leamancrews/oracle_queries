SELECT *
FROM   AP_TERMS
WHERE term_id IN
       (SELECT DISTINCT terms_id
           FROM   AP_INVOICES_ALL
             WHERE invoice_id = '124567'
       );       