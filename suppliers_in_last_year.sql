SELECT   

		 aia.invoice_id, pov.vendor_name, pov.segment1 "Vendor Num", pov.vendor_type_lookup_code, pov.FEDERAL_REPORTABLE_FLAG "FEDERAL_REPORTABLE", pov.TYPE_1099 "1099_TYPE", aia.payment_currency_code,
         aia.invoice_date, aia.invoice_num, aia.invoice_amount, aia.amount_paid, aia.description, 
         apsa.due_date, apsa.gross_amount, apsa.payment_status_flag "Paid", apsa.amount_remaining, apb.bank_name, apb.bank_branch_name, aca.check_date, aca.check_number, aca.status_lookup_code
         
FROM

         ap_payment_schedules_all apsa,
         ap_invoices_all aia,
         ce_bank_branches_simple_v apb,
         poz_suppliers_v pov,
         ap_checks_all aca,
         ap_invoice_payments_all aipa
         
         
WHERE 

	 1=1
	 AND aia.invoice_id = apsa.invoice_id(+)
     AND aia.vendor_id = pov.vendor_id
     AND aipa.invoice_id = aia.invoice_id
     AND aca.check_id = aipa.check_id
     AND apsa.payment_status_flag = 'Y'
      AND aipa.org_id != '300000001067110'
     AND aipa.accounting_date  > '2017-04-16'

 
ORDER BY aia.invoice_date DESC
