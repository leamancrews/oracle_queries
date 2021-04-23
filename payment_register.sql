SELECT  nvl(cpd.payment_document_name, :c_nls_none_ep) c_check_stock_name,
        ch.check_number c_check_number,
        TO_CHAR(ch.check_date,'YYYY-MM-DD')  c_check_date,
        ch.amount  c_amount ,
        nvl(substr(ch.remit_to_supplier_name,1,39),substr(ch.vendor_name,1,39)) c_vendor_name,
        substr(pssv.vendor_site_code,1,10),
        nvl(ch.remit_to_address_name,pssv.vendor_site_code) c_vendor_site_code,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.address_line1,1,35),substr(hzl.address1,1,35))
        c_address_line1,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.address_line2,1,35),substr(hzl.address2,1,35))
        c_address_line2,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.address_line3,1,35),substr(hzl.address3,1,35))
        c_address_line3,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.city,1,20),substr(hzl.city,1,20))
        c_city,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.state,1,15),substr(hzl.state,1,15))
        c_state,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.zip,1,15),substr(hzl.postal_code,1,15))
        c_zip,
        decode(nvl(ch.remit_to_supplier_name,'-999999'),'-999999',substr(pssv.country,1,25),substr(hzl.country,1,25))
        c_country,
        TO_CHAR(ch.cleared_date,'YYYY-MM-DD') c_cleared_date,
        ch.cleared_amount c_cleared_amount,
        lk2.displayed_field c_nls_status,
        br.bank_name  c_bank,
        br.bank_branch_name  c_branch,
        ch.bank_account_name  c_account,
		/* rallamse, commented as not referred in DT or Layout template, column does not exist in Fusion schema 
        ch.bank_account_id  c_accountid,*/
        br.branch_party_id  c_bank_branch,
        ba.currency_code  c_currency_code,
        ch.currency_code  c_pay_currency_code, 
	AP_APXMTDCR_XMLP_PKG.c_currency_descformula(ba.currency_code) C_CURRENCY_DESC, 
	AP_APXMTDCR_XMLP_PKG.c_pay_currency_descformula(ch.currency_code) C_PAY_CURRENCY_DESC, 
	AP_APXMTDCR_XMLP_PKG.check_flag(ba.currency_code, ch.currency_code) C_CHECK_CURR_FLAG,
	ch.doc_sequence_value C_DOC_SEQUENCE_VALUE
	--,&c_amount C_AMOUNT_FOR_SUM
FROM    ap_checks_all ch, 
        ce_payment_documents cpd,
        ce_bank_accounts ba,
        ce_bank_acct_uses_all cbau, 
        ce_bank_branches_v br,
        ap_lookup_codes  lk2,
        fnd_territories_vl ft,
	poz_supplier_sites_v pssv,
	HZ_PARTY_SITES hps,
	HZ_LOCATIONS hzl
where  cpd.payment_document_id(+) = ch.payment_document_id 
  and   ch.ce_bank_acct_use_id = cbau.bank_acct_use_id
  and   cbau.bank_account_id = ba.bank_account_id
  and   ba.bank_branch_id = br.branch_party_id
  and   ch.vendor_id = pssv.vendor_id(+)
  and	ch.vendor_site_id = pssv.vendor_site_id(+)
  and   ch.remit_to_address_id = hps.party_site_id(+)
  and   hps.location_id = hzl.location_id(+)
  and   ch.payment_type_flag = nvl(:P_PAYMENT_TYPE,
	ch.payment_type_flag )
  and   trunc(ch.check_date) between
        (:P_FROM_DATE) and
        (:P_TO_DATE)
  and   ch.country = ft.territory_code(+)
  and   lk2.lookup_type = 'CHECK STATE'
  and   lk2.lookup_code = ch.status_lookup_code
  and   ch.org_id = :P_BUSINESS_UNIT /* Added rallamse for org_id */
order by upper(br.bank_name), 
      upper(br.bank_branch_name), 
      upper(ch.bank_account_name),
      ch.currency_code,
      cpd.payment_document_name,
      ch.check_number

