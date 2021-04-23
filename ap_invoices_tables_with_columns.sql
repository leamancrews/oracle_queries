select  aia.invoice_id 
            ,aia.invoice_num
            ,aia.invoice_date 
            ,aia.invoice_amount
            ,aial.line_number 
            ,fit.description line_type 
           ,aial.amount line_amount
            ,aial.po_header_id
            ,aial.po_line_id
             ,aial.po_line_location_id
            ,aial.po_distribution_id
              ,aial.po_release_id
           ,aida.distribution_line_number
          ,aida.line_type_lookup_code
          ,aida.dist_code_combination_id
          ,aida.amount distribution_amount
  from ap_invoices_all aia
            ,ap_invoice_lines_all aial
            ,fnd_lookup_values fit
            ,ap_invoice_distributions_all aida
 WHERE 1 = 1 
   AND aia.invoice_id = aial.invoice_id
   AND aial.invoice_id = aida.invoice_id
   AND aial.line_number = aida.invoice_line_number
   AND aial.line_type_lookup_code = fit.lookup_code
   AND fit.lookup_type = 'INVOICE LINE TYPE'
   AND aia.invoice_date > sysdate - 200
   AND aia.invoice_id =
   order by aial.line_number;