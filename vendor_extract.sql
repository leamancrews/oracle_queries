SELECT *
        FROM (SELECT distinct pv.vendor_id V_VENDOR_ID,
                     pv.segment1  supplier_no, 
                     pv.vendor_name  V_VENDOR_NAME, 
                     pv.vendor_name_alt alias, 
                      pv.vendor_type_lookup_code  supplier_type, 
                     (SELECT name
                        FROM apps.AP_TERMS AT
                       WHERE at.term_id = pv.terms_id)
                       payment_terms, 
                     pv.vat_registration_num tax_reg_no,
                     decode(pv.num_1099,NULL,decode(pv.INDIVIDUAL_1099,NULL,NULL,pv.INDIVIDUAL_1099),pv.num_1099) taxpayer_id, 
                     pv.tax_reporting_name,
                     pv.small_business_flag,
                     pv.enforce_ship_to_location_code, 
                     (SELECT routing_name
                        FROM apps.RCV_ROUTING_HEADERS RH
                       WHERE rh.routing_header_id = pv.receiving_routing_id) 
                        receipt_routing,
                     DECODE(pv.inspection_required_flag || pv.receipt_required_flag,'NN', '2-Way', 'NY', '3-Way', 'YY', '4-Way', pv.inspection_required_flag ||          
                        pv.receipt_required_flag) match_approval, 
                     pv.qty_rcv_tolerance, 
                     pv.qty_rcv_exception_code, 
                     pv.days_early_receipt_allowed, 
                     pv.days_late_receipt_allowed, 
                     pv.allow_substitute_receipts_flag,
                     pv.allow_unordered_receipts_flag, 
                     pv.receipt_days_exception_code, 
                       pvs.payment_method_lookup_code payment_method,
                    pv.invoice_currency_code,
                     pv.invoice_amount_limit,
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_type = 'INVOICE MATCH OPTION'
                         AND lookup_code = pvs.match_option) 
                        inv_match_option,
                     pv.hold_all_payments_flag,
                     pv.payment_currency_code,
                     pv.payment_priority, 
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_type = 'TERMS DATE BASIS'
                         AND lookup_code = pv.terms_date_basis) 
                        term_date_basis ,
                      upper(pv.pay_date_basis_lookup_code) 
                        pay_date_basis,
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_type = 'PAY GROUP'
                         AND upper(lookup_code) = upper(pv.pay_group_lookup_code)) pay_group, 
                         --AND lookup_code = pv.pay_group_lookup_code)                  
                     pv.always_take_disc_flag,
                     pv.exclude_freight_from_discount,
                     pv.auto_calculate_interest_flag,
                     pv.organization_type_lookup_code, 
                     pv.type_1099,
                     pv.start_date_active,
                     pv.end_date_active, 
                     PV.STATE_REPORTABLE_FLAG,
                     PV.FEDERAL_REPORTABLE_FLAG,
                     PV.PAYMENT_METHOD_LOOKUP_CODE,
                     PV.EXCLUSIVE_PAYMENT_FLAG,
                     PV.NUM_1099,
                     PV.ALLOW_AWT_FLAG,
                     PV.AWT_GROUP_ID,
                     PV.TAX_VERIFICATION_DATE,
                     pv.inspection_required_flag,--n
                     pv.receipt_required_flag, --n
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_type = 'INVOICE MATCH OPTION'
                         AND lookup_code = pv.match_option) v_invoice_match_option,
                     pv.attribute_category V_ATTRIBUTE_CATEGORY,                    
                     pv.attribute1 V_ATTRIBUTE1,
                     pv.attribute2 V_ATTRIBUTE2,
                     pv.attribute3 V_ATTRIBUTE3,
                     pv.attribute4 V_ATTRIBUTE4,
                     pv.attribute5 V_ATTRIBUTE5,
                     pv.attribute6 V_ATTRIBUTE6,
                     pv.attribute7 V_ATTRIBUTE7,
                     pv.attribute8 V_ATTRIBUTE8,
                     pv.attribute9 V_ATTRIBUTE9,
                     pv.attribute10 V_ATTRIBUTE10,
                     pv.attribute11 V_ATTRIBUTE11,
                     pv.attribute12 V_ATTRIBUTE12,
                     pv.attribute13 V_ATTRIBUTE13,
                     pv.attribute14 V_ATTRIBUTE14,
                     pv.attribute15 V_ATTRIBUTE15,
                     pvs.vendor_site_id,
                     81 VS_ORG_ID,
                     pvs.address_line1, 
                     pvs.address_line2, 
                     pvs.address_line3, 
                     pvs.address_line4, 
                     pvs.city, 
                     pvs.state, 
                     pvs.zip,
                     PVS.INVOICE_CURRENCY_CODE VS_INVOICE_CURRENCY_CODE,
                     PVS.PAYMENT_CURRENCY_CODE VS_PAYMENT_CURRENCY_CODE,
                     PVS.HOLD_ALL_PAYMENTS_FLAG VS_HOLD_ALL_PAYMENTS_FLAG,
                     PVS.TERMS_DATE_BASIS,
                     upper(PVS.PAY_DATE_BASIS_LOOKUP_CODE),
                     PVS.EXCLUSIVE_PAYMENT_FLAG VS_EXCLUSIVE_PAYMENT_FLAGE,
                     PVS.REMITTANCE_EMAIL,
                     (SELECT name
                        FROM apps.AP_TERMS AT
                       WHERE at.term_id = pvs.terms_id)
                       vs_payment_terms,                                                                                      
                      PVS.PAY_GROUP_LOOKUP_CODE VS_PAY_GROUP_LOOKUP_CODE, 
                      'SUPPLIER-INVOICE-TOLERANCE' vs_goods_tolerance_name,
                       PVS.ALLOW_AWT_FLAG VS_ALLOW_AWT_FLAG,
                           ( SELECT name
                       FROM ap_awt_groups
                      WHERE group_id= pvs.awt_group_id)
                      VS_AWT_GROUP_ID,
                     (SELECT    segment1
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg1,
                     (SELECT    segment2
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg2,
                    (SELECT    segment3
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg3,
                    (SELECT    segment4
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg4, 
                    (SELECT    segment5
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg5,   
                    (SELECT    segment6
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.accts_pay_code_combination_id)
                        vs_liablity_seg6,                                                                  
                     (SELECT    segment1
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg1,
                     (SELECT    segment2
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg2,
                     (SELECT    segment3
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg3,
                     (SELECT    segment4
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg4,
                     (SELECT    segment5
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg5,
                     (SELECT    segment6
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.prepay_code_combination_id)
                        vs_prepay_seg6,                                                                                                                       
                     (SELECT    segment1
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg1,
                     (SELECT    segment2
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg2, 
                     (SELECT    segment3
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg3,
                     (SELECT    segment4
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg4,
                     (SELECT    segment5
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg5,
                     (SELECT    segment6
                        FROM GL_CODE_COMBINATIONS
                       WHERE code_combination_id =
                                pvs.future_dated_payment_ccid)
                        vs_bills_pay_seg6,                                  
                     (SELECT location_code
                        FROM HR_LOCATIONS
                       WHERE location_id = pvs.bill_to_location_id) 
                        bill_to_loc,
                     (SELECT location_code
                        FROM HR_LOCATIONS
                       WHERE location_id = pvs.ship_to_location_id) 
                        ship_to_loc,
                      pvs.pay_on_code 
                        pay_on,
                     (SELECT pvs1.vendor_site_code
                        FROM PO_VENDOR_SITES_ALL PVS1
                       WHERE pvs1.vendor_site_id = pvs.default_pay_site_id)
                        alt_pay_site,
                     pvs.pay_on_receipt_summary_code    
                        inv_summary_level,
                     pvs.create_debit_memo_flag,
                     pvs.gapless_inv_num_flag gapless_inv_num,
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_TYPE = 'FOB'
                         AND lookup_code = pvs.fob_lookup_code)
                        fob , 
                     (SELECT meaning
                        FROM FND_LOOKUP_VALUES
                       WHERE lookup_TYPE = 'FREIGHT TERMS'
                         AND lookup_code = pvs.freight_terms_lookup_code)
                       freight_terms , 
                     pvs.attribute_category VS_ATTRIBUTE_CATEGORY,                
                     pvs.attribute1 VS_ATTRIBUTE1,
                     pvs.attribute2 VS_ATTRIBUTE2,
                     pvs.attribute3 VS_ATTRIBUTE3,
                     pvs.attribute4 VS_ATTRIBUTE4,
                     pvs.attribute5 VS_ATTRIBUTE5,
                     pvs.attribute6 VS_ATTRIBUTE6,
                     pvs.attribute7 VS_ATTRIBUTE7,
                     pvs.attribute8 VS_ATTRIBUTE8,
                     pvs.attribute9 VS_ATTRIBUTE9,
                     pvs.attribute10 VS_ATTRIBUTE10,
                     pvs.attribute11 VS_ATTRIBUTE11,
                     pvs.attribute12 VS_ATTRIBUTE12,
                     pvs.attribute13 VS_ATTRIBUTE13,
                     pvs.attribute14 VS_ATTRIBUTE14,
                     pvs.attribute15 VS_ATTRIBUTE15,
                     (SELECT distribution_set_name
                        FROM AP_DISTRIBUTION_SETS_ALL AD
                       WHERE ad.distribution_set_id = pvs.distribution_set_id)
                        distribution_set_name,
                     pvs.country_of_origin_code country_of_origin,
                     pvs.duns_number,
                     pvs.country,
                     pvs.vendor_site_code address_name,
                     pvs.language,
                     pvs.supplier_notif_method notif_method,
                     pvs.area_code,
                     pvs.phone,
                     pvs.fax_area_code,
                     pvs.fax,
                     pvs.telex,
                     pvs.email_address,
                     pvs.purchasing_site_flag purchasing_site,
                     pvs.pay_site_flag pay_site,
                     pvs.primary_pay_site_flag primary_pay_site,
                     pvs.rfq_only_site_flag rfq_only_site,
                     pvs.customer_num,
                     pvs.ece_tp_location_code edi_location,
                     --decode(pvs.tax_reporting_site_flag,'Y',pvs.vendor_site_code,NULL) reporting_site,
                     pvs.tax_reporting_site_flaG,
                     pvc.url,
                     pvc.prefix,
                     pvc.first_name,
                     pvc.middle_name,
                     pvc.last_name,
                     pvc.title,
                     pvc.email_address c_email_address,
                     pvc.area_code c_area_code,
                     pvc.phone c_phone,
                     pvc.fax_area_code c_fax_area_code,
                     pvc.fax c_fax,
                     (select employee_number from per_all_people_f where person_id=pv.employee_id AND rownum=1) employee_number ,PV.CUSTOMER_NUM V_CUST_NUM                        
                FROM PO_VENDORS PV,
                     PO_VENDOR_SITES_ALL PVS,
                     PO_VENDOR_CONTACTS PVC
               WHERE
                  (pv.END_DATE_ACTIVE is null or pv.END_DATE_ACTIVE > sysdate)
                 and (pvs.inactive_date is null or pvs.inactive_date > sysdate)                
                 and pv.vendor_id = pvs.vendor_id
                 AND pvs.vendor_site_id = pvc.vendor_site_id(+)
               and ( pv.vendor_type_lookup_code <>'EMPLOYEE' OR pv.vendor_type_lookup_code IS NULL)
                 AND pvs.org_id IN
                        (1)
                        ) vendors,
             (SELECT bbnch.bank_number,
                     bbnch.bank_name,
                     bbnch.bank_branch_name,
                     bbnch.bank_num,
                    bbnch.description,
                     bacct.bank_account_name,
                     bacct.bank_account_num,
                     bacct.currency_code curr,
                     bacct.check_digits,
                     bbnch.country ctry,
                     bauses.vendor_site_id vsi,
                     bauses.primary_flag primary,
                     bacct.attribute_category,--n
                     bacct.attribute1,bacct.attribute2,bacct.attribute3,bacct.attribute4,bacct.attribute5,bacct.attribute6,bacct.attribute7,bacct.attribute8,
                     bacct.attribute9,bacct.attribute10,bacct.attribute11,bacct.attribute12,bacct.attribute13,bacct.attribute14,bacct.attribute15
                     ,bauses.start_date --n
                FROM AP_BANK_ACCOUNT_USES_ALL BAUSES,
                     AP_BANK_BRANCHES BBNCH,
                     AP_BANK_ACCOUNTS BACCT
               WHERE bauses.external_bank_account_id = bacct.bank_account_id
                 AND bacct.bank_branch_id = bbnch.bank_branch_id
                 AND (Bauses.end_date IS  NULL or Bauses.end_date > sysdate)
                 ) BANKS
       WHERE VENDORS.vENDOR_SITE_ID = banks.vsi(+)
       

begin
dbms_application_info.set_client_info(1);
end;