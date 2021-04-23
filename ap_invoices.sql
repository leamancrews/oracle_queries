select
    haou.name                           "Operating Unit",
    s.segment1                          "Supplier Number",
    ass.vendor_site_code                "Site Name",
    ai.invoice_num                      "Invoice Num",
    --
    ai.cust_registration_number         "Customer Taxpayer Id",
    ai.invoice_type_lookup_code         "Type",
    ph.segment1                         "PO Number",
    s.vendor_name                       "Trading Partner",
    ai.invoice_date                     "Invoice Date",
    ai.invoice_currency_code            "Invoice Currency",
    ai.invoice_amount                   "Invoice Amount",
    ai.total_tax_amount                 "Tax Amount",
    ai.control_amount                   "Tax Control Amount",
    ap_invoices_utility_pkg.get_amount_withheld (ai.invoice_id)     "Withheld Amount",
    ap_prepay_utils_pkg.get_prepaid_amount(ai.invoice_id)           "Prepaid Amount",
    ai.gl_date                          "GL Date",
    ai.payment_currency_code            "Payment Currency",
    ai.payment_cross_rate_date          "Payment Rate Date",
    ai.payment_cross_rate_type          "Payment Rate Type",
    ai.payment_cross_rate               "Payment Rate",
    dset.distribution_set_name          "Distribution Set",
    ai.description                      "Description",
    ai.quick_credit                     "Quick Credit",
    ap_invoices_utility_pkg.get_invoice_num (ai.credited_invoice_id) "Credited Invoice",
    ass.match_option                    "Match Action",
    pp.segment1                         "Project",
    pt.task_number                      "Task",
    ai.expenditure_item_date            "Expenditure Item Date",
    ai.expenditure_type                 "Expenditure Date",
    ai.expenditure_organization_id      "Expenditure Organization-",
    ai.exchange_rate_type               "Rate Type",
    ai.exchange_date                    "Exchange Date",
    ai.exchange_rate                    "Exchange Rate",
    ai.terms_date                       "Terms Date",
    at.name                             "Terms",
    ai.payment_method_code              "Payment Method-",
    ai.pay_group_lookup_code            "Pay Group",
    ai.invoice_type_lookup_code         "Prepayment Type", -- depends on earliest_settlement_date
    ai.earliest_settlement_date         "Settlement Date",
    ai.taxation_country                 "Taxation Country-",
    ai.trx_business_category            "Business Category-",
    ai.user_defined_fisc_class          "Fiscal Classification",
    ap_invoices_utility_pkg.get_invoice_num(ai.tax_related_invoice_id)  "Related Invoice",
    ai.document_sub_type                "Invoice Sub-Type-",
    ai.self_assessed_tax_amount         "Self Assessed Tax Amount",
    ai.tax_invoice_internal_seq         "Internal Sequence Number",
    ai.supplier_tax_invoice_number      "Supplier Tax Invoice Number",
    ai.tax_invoice_recording_date       "Internal Recording Date",
    ai.supplier_tax_invoice_date        "Supplier Tax Inv Date",
    ai.supplier_tax_exchange_rate       "Supplier Tax Inv Exch. Rate",
    ai.port_of_entry_code               "Customs Location Code",
    ai.remit_to_supplier_name           "Remit-To Supplier Name",
    ai.remit_to_supplier_site           "Remit-To Supplier Site Name",
    ibybnk.bank_account_name            "Remit-To Bank Account Name",
    ibybnk.bank_account_num             "Remit-To Bank Account Number",
    ai.release_amount_net_of_tax        "Release Amount Net of Tax",
    --
    ai.org_id,
    ai.vendor_id,
    ai.vendor_site_id,
    ai.invoice_id
from  
    ap_invoices ai,
    ap_suppliers s,
    ap_supplier_sites ass,
    hr_all_organization_units haou,
    po_headers ph,
    ap_distribution_sets dset,
    pa_projects_all pp,
    pa_tasks pt,
    ap_terms at,
    iby_ext_bank_accounts ibybnk
where
    1=1
and s.vendor_id = ai.vendor_id
and ass.vendor_site_id = ai.vendor_site_id
and haou.organization_id = ai.org_id
and ph.po_header_id(+) = ai.quick_po_header_id
and dset.distribution_set_id(+) = ai.distribution_set_id
and pp.project_id(+) = ai.project_id
and pt.task_id(+) = ai.task_id
and at.term_id(+) = ai.terms_id
and ibybnk.ext_bank_account_id(+) = ai.external_bank_account_id
--
--and s.segment1 = '1008'
and ai.invoice_num = 'OPS200839086'
order by
    1,2,3,4