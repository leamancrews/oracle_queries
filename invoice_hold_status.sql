SELECT *
  FROM (SELECT api.invoice_id, api.invoice_date AS invoice_date,
               api.invoice_num AS invoice_num, pov.vendor_id AS vendor_id,
               pov.vendor_name AS supplier_name,
               apd.inv_lines AS total_inv_lines,
               NVL (hold_tab_info.hold_inv_lines, 0) AS total_line_holds,
               NVL
                  (CEIL (  (hold_tab_info.hold_inv_lines * 100)
                         / DECODE (apd.inv_lines, 0, 1, apd.inv_lines)
                        ),
                   0
                  ) AS percentage_line_hold,
               DECODE (hold_tab_info.hold_inv_lines,
                       NULL, 'N',
                       0, 'N',
                       'Y'
                      ) AS defect,
               DECODE (hold_tab_info.hold_inv_lines,
                       NULL, 0,
                       0, 0,
                       1
                      ) AS defect_count,
               1 inv_count, NVL (hold_count.hold_cnt, 0) AS total_inv_holds,
               NVL (c.hold_os, 0) AS days_outstanding,
               NVL (api.invoice_amount, 0) AS total_invoice_amount,
               NVL (hold_tab_info.hold_amount, 0) AS total_hold_amount,
               NVL
                  (CEIL (  (hold_tab_info.hold_amount * 100)
                         / DECODE (api.invoice_amount,
                                   0, 1,
                                   api.invoice_amount
                                  )
                        ),
                   0
                  ) AS percentage_amount_hold
          FROM apps.ap_invoices_all api,
               (SELECT   invoice_id, COUNT (invoice_id) inv_lines
                    FROM apps.ap_invoice_distributions_all
                GROUP BY invoice_id) apd,
               (SELECT   invoice_id, COUNT (hold_lookup_code) hold_cnt
                    FROM apps.ap_holds_all
                   WHERE 1 = 1 AND line_location_id IS NOT NULL
                GROUP BY invoice_id) hold_count,
               (SELECT   invoice_id, COUNT (hold_tab.line_num) hold_inv_lines,
                         SUM (hold_tab.hold_amount) hold_amount
                    FROM (SELECT DISTINCT api.invoice_id invoice_id,
                                          apd.distribution_line_number
                                                                     line_num,
                                          apd.amount hold_amount
                                     FROM apps.ap_invoices_all api,
                                          apps.ap_invoice_distributions_all apd,
                                          apps.po_distributions_all pod,
                                          apps.ap_holds_all aph
                                    WHERE 1 = 1
                                      AND api.invoice_id = apd.invoice_id
                                      AND aph.invoice_id(+) = api.invoice_id
                                      AND api.cancelled_date IS NULL
                                      AND apd.po_distribution_id = pod.po_distribution_id(+)
                                      AND aph.line_location_id =
                                                          pod.line_location_id
                                      AND aph.line_location_id IS NOT NULL) hold_tab
                GROUP BY invoice_id) hold_tab_info,
               (SELECT   invoice_id, MAX (b.hold_os) hold_os
                    FROM (SELECT invoice_id,
                                 DECODE
                                    (status_flag,
                                     'R', (  TRUNC (NVL (last_update_date,
                                                         SYSDATE
                                                        )
                                                   )
                                           - TRUNC (hold_date)
                                      ),
                                     (TRUNC (SYSDATE) - TRUNC (hold_date))
                                    ) hold_os
                            FROM apps.ap_holds_all
                           WHERE line_location_id IS NOT NULL) b
                GROUP BY invoice_id) c,
               apps.po_vendors pov
         WHERE 1 = 1
           AND hold_tab_info.invoice_id(+) = api.invoice_id
           AND c.invoice_id(+) = api.invoice_id
           AND api.invoice_id = apd.invoice_id
           AND api.vendor_id = pov.vendor_id(+)
           AND api.cancelled_date IS NULL
           AND api.invoice_id = hold_count.invoice_id(+))
 WHERE invoice_num = 'Your Invoice number';
