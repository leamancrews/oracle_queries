select
    haou.name                           "Operating Unit",
    s.segment1                          "Supplier Number",
    ass.vendor_site_code                "Site Name",
    ai.invoice_num                      "Invoice Num",
    --
    ail.line_number                     "Num",
    ail.line_type_lookup_code           "Type",
    ail.amount                          "Amount",
    ph.segment1                         "PO Number",
    pr.release_num                      "PO Release Num",
    nvl(pl.line_num_display, to_char (pl.line_num))  "PO Line Num",
    pll.shipment_num                    "PO Shipment Num",
    pll.matching_basis                  "Match Basis",
    pd.distribution_num                 "PO Distribution",
    rsh.receipt_num                     "Receipt Number",
    rsl.line_num                        "Receipt Line",
    ail.quantity_invoiced               "Qty Invoiced",
    ail.unit_meas_lookup_code           "UOM",
    ail.unit_price                      "Unit Price",
    ail.description                     "Description",
    ail.final_match_flag                "Final Match",
    ppf.full_name                       "Requester",
    ail.accounting_date                 "GL Date",
    ads.distribution_set_name           "Distribution Set",
    fnd_flex_ext.get_segs('SQLGL','GL#',
        gl.chart_of_accounts_id,
        ail.default_dist_ccid)          "Default Distribution Account",
    ail.overlay_dist_code_concat        "Overlay Account",
    ail.balancing_segment               "Balance Segment",
    ail.cost_center_segment             "Cost Centre Segment",
    ail.account_segment                 "Account Segment",
    ail.prorate_across_all_items        "Prorate Across All Item Lines",
    ail.deferred_acctg_flag             "Deferred Option",
    ail.def_acctg_start_date            "Deferred Start Date",
    ail.def_acctg_end_date              "Deferred End Date",
    ail.def_acctg_number_of_periods     "Deferred Number of Periods",
    ail.def_acctg_period_type           "Deferred Period Type",
    ail.manufacturer                    "Manufacturer",
    ail.model_number                    "Model",
    ail.serial_number                   "Serial Number",
    ail.warranty_number                 "Warranty Number",
    msi.segment1                        "Inventory Item",
    ail.item_description                "Item Description",
    ppet.name                           "Cost Factor Name",
    ail.assets_tracking_flag            "Track As Asset",
    fabc.book_type_name                 "Asset Book",
    fc.segment1||'.'||fc.segment2       "Asset Category",
    --correction                     "correction",
    aic.invoice_num                     "Corrected Invoice",
    ail.corrected_line_number           "Corrected Invoice Line Num",
    ail.type_1099                       "Income Tax Type",
    ail.income_tax_region               "Income Tax Region",
    ail.tax_regime_code                 "Tax Regime",
    ail.tax                             "Tax",
    ail.tax_status_code                 "Tax Status",
    ail.tax_rate_code                   "Tax Rate Name",
    ail.tax_rate                        "Tax Rate",
    ail.tax_jurisdiction_code           "Tax Jurisdiction",
    ail.tax_classification_code         "Tax Classification Code",
    ail.primary_intended_use            "Primary Intended Use",
    ail.assessable_value                "Assessable Value",
    hr.location_code                    "Ship To",
    ail.product_fisc_classification     "Product Fiscal Classification",
    ail.user_defined_fisc_class         "Fiscal Classification",
    ail.trx_business_category           "Business Category",
    ail.product_type                    "Product Type",
    ail.product_category                "Product Category",
    ail.control_amount                  "Control Amount",
    ail.included_tax_amount             "Include Tax Amount",
    ail.total_rec_tax_amount            "Recoverable Tax Amount",
    ail.total_nrec_tax_amount           "Nonrecoverable Tax Amount",
    awt.name                            "Invoice Withholding Tax",
    awt_pay.name                        "Payment Withholding Tax",
    pp.segment1                         "Project",
    pt.task_number                      "Task",
    ail.expenditure_item_date           "Expenditure Item Date",
    ail.expenditure_type                "Expenditure Type",
    ail.expenditure_organization_id     "Expenditure Organization", --
    ail.pa_quantity                     "Project Quantity",
    aii.invoice_num                     "Intercompany Invoice Num",
    ail.pa_cc_ar_invoice_line_num       "Intercompany Invoice Line Num",
    aii.invoice_num                     "Prepayment Invoice Number",
    ail.prepay_line_number              "Prepayment Line Number",
    ail.invoice_includes_prepay_flag    "Invoice Includes Prepayment",
    ail.wfapproval_status               "Approval Status",
    --null                     "Distribution Total",
    ap_invoice_lines_utility_pkg.get_approval_status(
            ail.invoice_id, ail.line_number)    "Validation Status",
    ap_invoice_lines_utility_pkg.get_encumbered_flag(
            ail.invoice_id, ail.line_number)    "Encumbrance Status",
    ail.discarded_flag                  "Discarded",
    ail.cancelled_flag                  "Cancelled",
    ail.line_source                     "Line Source",
    ail.reference_1                     "Reference 1",
    ail.reference_2                     "Reference 2",
    ail.receipt_verified_flag           "Receipt Verified",
    ail.receipt_required_flag           "Receipt Required",
    ail.receipt_missing_flag            "Receipt Missing",
    --
    ai.org_id,
    ai.vendor_id,
    ai.vendor_site_id,
    ai.invoice_id
from  
    ap_invoices ai,
    ap_invoice_lines ail,
    ap_suppliers s,
    ap_supplier_sites ass,
    hr_all_organization_units haou,
    po_headers_all ph,
    po_releases_all pr,
    po_lines_all pl,
    po_line_locations_all pll,
    po_distributions_all pd,
    rcv_shipment_lines rsl,
    rcv_shipment_headers rsh,
    ap_distribution_sets ads,
    gl_ledgers gl,
    pon_price_element_types_vl ppet,
    fa_book_controls fabc,
    ap_invoices aic,
    hr_locations hr,
    ap_awt_groups awt,
    ap_awt_groups awt_pay,
    pa_projects_all pp,
    pa_tasks pt,
    ap_invoices_all aii,
    ap_invoices_all aip,
    per_all_people_f ppf,
    mtl_system_items msi,
    fa_categories fc
where
    1=1
and ail.invoice_id = ai.invoice_id
and s.vendor_id = ai.vendor_id
and ass.vendor_site_id = ai.vendor_site_id
and haou.organization_id = ai.org_id
and ph.po_header_id(+) = ail.po_header_id
and pr.po_release_id(+) = ail.po_release_id
and pl.po_line_id(+) = ail.po_line_id
and pll.line_location_id(+) = ail.po_line_location_id
and pd.po_distribution_id(+) = ail.po_distribution_id
and rsl.shipment_line_id(+) = ail.rcv_shipment_line_id
and rsh.shipment_header_id(+) = rsl.shipment_header_id
and ads.distribution_set_id(+) = ail.distribution_set_id
and gl.ledger_id = ail.set_of_books_id
and ppet.price_element_type_id(+) = ail.cost_factor_id
and fabc.book_type_code(+) = ail.asset_book_type_code
and aic.invoice_id(+) = ail.corrected_inv_id
and hr.location_id(+) = ail.ship_to_location_id
and awt.group_id(+) = ail.awt_group_id
and awt_pay.group_id(+) = ail.pay_awt_group_id
and pp.project_id(+) = ail.project_id
and pt.task_id(+) = ail.task_id
and aii.invoice_id(+) = ail.pa_cc_ar_invoice_id
and aip.invoice_id(+) = ail.prepay_invoice_id
and ppf.person_id (+) = ail.requester_id
and sysdate between ppf.effective_start_date (+) and ppf.effective_end_date (+)
and msi.organization_id (+) = oe_sys_parameters.value('MASTER_ORGANIZATION_ID')
and msi.inventory_item_id (+) = ail.inventory_item_id
and fc.category_id (+) = ail.asset_category_id
--
and s.segment1 = '1008'
and ai.invoice_num = 'OPS200839086'
--and ai.invoice_id = 60722
order by
    1,2,3,4