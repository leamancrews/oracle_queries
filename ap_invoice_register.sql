SELECT  
        hp.party_name c_vendor_name,
        upper(hp.party_name) c_upper_vendor_name,
        decode(:SORT_BY_ALTERNATE, 'Y', upper(pv.vendor_name_alt), upper(hp.party_name))      
        c_sort_vendor_name,
        inv1.invoice_num c_invoice_num,
        TO_CHAR(inv1.invoice_date,'YYYY-MM-DD') c_invoice_date,
        &P_dynamic_batch_orderby c_batch_id,
        &P_invoice_amount c_invoice_amount,
decode(inv1.payment_status_flag, 'Y', 0, (nvl(inv1.invoice_amount,0) 
- nvl(ap_invoices_pkg.get_amount_withheld(inv1.invoice_id),0)   -(ap_utilities_pkg.ap_round_currency((nvl(inv1.amount_paid,0)/inv1.payment_cross_rate),inv1.invoice_currency_code)) - 
(ap_utilities_pkg.ap_round_currency((nvl(inv1.discount_amount_taken,0)/inv1.payment_cross_rate),inv1.invoice_currency_code))))   c_amount_rem,
        inv1.description c_description,
        inv1.invoice_type_lookup_code
        c_invoice_type,
        null c_expense_accounting_flex,
        null c_liab_accounting_flex,
        dist.amount c_dist_amount,
        TO_CHAR(dist.accounting_date,'YYYY-MM-DD') c_accounting_date,
        dist.type_1099 c_type_1099,
        lines.line_number c_line_number,
        lines.description c_line_description,
        to_char(lines.amount, fnd_currency.get_format_mask(inv1.invoice_currency_code, 38))
               c_line_amount_f,
        alc1.displayed_field c_posted,
        nvl(bat.batch_name, :c_nls_na) c_batch_name,
        upper(nvl(bat.batch_name, :c_nls_na))
            c_upper_batch_name,
        inv1.invoice_id c_invoiceid,
        inv1.vendor_id c_vendor,
        substr(inv1.invoice_currency_code,1,15) c_currency_code,
        alc2.displayed_field c_dist_type,
        alc3.displayed_field c_line_type,
        dist.distribution_line_number c_dist_number,
        alc.displayed_field c_nls_invoice_type, 
        decode (inv1.doc_sequence_value , null, inv1.voucher_num,inv1.doc_sequence_value) c_voucher_num, --rchandan for bug#9709459
        inv1.LAST_UPDATE_DATE inv_LAST_UPDATE_DATE,
        inv1.LAST_UPDATED_BY  inv_LAST_UPDATED_BY, 
        inv1.CREATION_DATE    inv_CREATION_DATE, 
        inv1.CREATED_BY       inv_CREATED_BY,
        inv1.LAST_UPDATE_LOGIN  inv_LAST_UPDATE_LOGIN,
        lines.LAST_UPDATE_DATE  lines_LAST_UPDATE_DATE,
        lines.LAST_UPDATED_BY   lines_LAST_UPDATED_BY, 
        lines.CREATION_DATE     lines_CREATION_DATE, 
        lines.CREATED_BY        lines_CREATED_BY,
        lines.LAST_UPDATE_LOGIN lines_LAST_UPDATE_LOGIN,
        dist.LAST_UPDATE_DATE   dist_LAST_UPDATE_DATE,
        dist.LAST_UPDATED_BY    dist_LAST_UPDATED_BY, 
        dist.CREATION_DATE      dist_CREATION_DATE, 
        dist.CREATED_BY         dist_CREATED_BY,
        dist.LAST_UPDATE_LOGIN  dist_LAST_UPDATE_LOGIN,
	decode(dist.distribution_line_number,null,null,&C_exp_flexfield) C_exp_flexfield, 
	&C_liab_flexfield c_liab_flexfield
FROM    ap_invoices_all inv1,
        poz_suppliers_v pv, /* rallamse, po_vendors replaced with poz_suppliers_v */
        ap_invoice_lines_all lines,
        ap_invoice_distributions_all dist,
        gl_code_combinations GC,
        &P_gl_code_combinations2
        ap_batches_all bat,
        ap_lookup_codes alc,
        ap_lookup_codes alc1,
        ap_lookup_codes alc2,
        ap_lookup_codes alc3,
	hz_parties hp
WHERE   inv1.vendor_id = pv.vendor_id(+)--rchandan for bug#9709459 added outer join
AND   (:P_VENDOR_ID IS NULL
           OR (:P_VENDOR_ID IS NOT NULL 
                   AND pv.vendor_id = :P_VENDOR_ID))
AND     bat.batch_id(+) = inv1.batch_id
AND   inv1.party_id=hp.party_id --26405276 
&C_INVOICE_ID_PREDICATE
&C_batch_predicate
&C_match_status_predicate
&C_INV_TYPE_PRED
&C_ACCOUNTING_DATE_PREDICATE
&C_invoice_cancelled_predicate
&C_created_by_predicate
&C_start_date_predicate
&C_end_date_predicate
AND        GC.code_combination_id(+) = dist.dist_code_combination_id
AND inv1.org_id=:P_BUSINESS_UNIT
&C_gl_ccid2_predicate
AND       alc.lookup_type         = 'INVOICE TYPE'
AND       alc.lookup_code         = inv1.invoice_type_lookup_code
AND       alc1.lookup_type (+)  = 'POSTING STATUS'
AND       alc1.lookup_code (+)  = dist.posted_flag
AND       alc2.lookup_type (+)  = 'INVOICE DISTRIBUTION TYPE'
AND       alc2.lookup_code (+) = dist.line_type_lookup_code
AND       alc3.lookup_type (+) = 'INVOICE LINE TYPE'
AND       alc3.lookup_code (+) = lines.line_type_lookup_code
AND       nvl(bat.batch_id,1) = nvl(nvl(:P_BATCH,bat.batch_id),1)
ORDER BY  inv1.invoice_currency_code,c_batch_name,c_sort_vendor_name,c_invoice_num,c_invoice_amount,c_line_number,c_line_type,c_line_description,c_line_amount_f,c_dist_number,c_batch_id,
                   &C_orderby_batch_id
                   decode(:SORT_BY_ALTERNATE, 'Y', upper(vendor_name_alt), upper(vendor_name)),
                   invoice_num,
                   lines.line_number,
                   dist.distribution_line_number
