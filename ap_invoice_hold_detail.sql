SELECT *
  FROM (SELECT 'HOLDS - SOURCE1' AS SOURCE, api.invoice_date AS invoice_date,
               api.invoice_num AS invoice_num,
               pov.vendor_name AS supplier_name,
               apd.distribution_line_number AS inv_line_num,
               apd.amount AS invoice_line_amount,
               DECODE (aph.hold_reason, NULL, 'N', 'Y') AS defect,
               poh.segment1 AS po_number, por.release_num AS po_release_num,
               pol.line_num AS po_line_num, aph.hold_date AS hold_date,
               aph.hold_lookup_code AS hold_lookup_code,
               aph.hold_reason AS hold_reason,
               aph.last_update_date AS release_date,
               (  TRUNC (NVL (aph.last_update_date, SYSDATE))
                - TRUNC (aph.hold_date)
               ) AS days_os,
               pod.quantity_ordered AS shipment_quantity_ordered,
               pod.quantity_delivered AS shipment_quantity_delivered,
               pod.quantity_billed AS shipment_quantity_billed,
               api.invoice_received_date AS invoice_received_date,
               pob.agent_name AS buyer,
               povs.vendor_site_code AS supplier_site,
               ppf.full_name AS requestor, rcvh.receipt_num AS receipt_number,
               rcv.quantity AS received_accepted_qty,
               rcv.unit_of_measure AS uom,
               rcv.creation_date AS receipt_transacted_date,
               rcv.transaction_date AS receipt_date
          FROM apps.ap_invoices_all api,
               apps.ap_invoice_distributions_all apd,
               apps.po_distributions_all pod,
               apps.po_headers_all poh,
               apps.po_releases_all por,
               apps.po_lines_all pol,
               apps.ap_holds_all aph,
               apps.po_vendors pov,
               apps.po_agents_v pob,
               apps.po_vendor_sites_all povs,
               apps.rcv_transactions rcv,
               apps.rcv_shipment_headers rcvh,
               apps.po_line_locations_all pll,
               apps.hr_locations_all loc,
               apps.per_all_people_f ppf
         WHERE 1 = 1
           AND api.invoice_id = apd.invoice_id
           AND aph.invoice_id(+) = api.invoice_id
           AND api.vendor_id = pov.vendor_id(+)
           AND api.cancelled_date IS NULL
           AND apd.po_distribution_id = pod.po_distribution_id(+)
           AND aph.line_location_id = pod.line_location_id
           AND poh.po_header_id(+) = pod.po_header_id
           AND por.po_release_id(+) = pod.po_release_id
           AND pol.po_header_id(+) = pod.po_header_id                        --
           AND pol.po_line_id(+) = pod.po_line_id
           AND poh.agent_id = pob.agent_id(+)
           AND povs.vendor_site_id(+) = poh.vendor_site_id
           AND apd.po_distribution_id = rcv.po_distribution_id(+)
           AND rcvh.shipment_header_id(+) = rcv.shipment_header_id
           AND rcv.destination_type_code(+) = 'RECEIVING'
           AND pll.line_location_id(+) = pod.line_location_id
           AND pll.ship_to_location_id = loc.location_id(+)
           AND pod.deliver_to_person_id = ppf.person_id(+)
           AND NVL (ppf.effective_start_date, SYSDATE) <= SYSDATE
           AND NVL (ppf.effective_end_date, SYSDATE + 1) > SYSDATE
        UNION
        SELECT 'Holds NotLinked To PO-Source2' AS SOURCE,
               api.invoice_date AS invoice_date,
               api.invoice_num AS invoice_num,
               pov.vendor_name AS supplier_name,
               apd.distribution_line_number AS inv_line_num,
               apd.amount AS invoice_line_amount,
               DECODE (aph.hold_reason, NULL, 'N', 'Y') AS defect,
               poh.segment1 AS po_number, por.release_num AS po_release_num,
               pol.line_num AS po_line_num, aph.hold_date AS hold_date,
               aph.hold_lookup_code AS hold_lookup_code,
               aph.hold_reason AS hold_reason,
               aph.last_update_date AS release_date,
               (  TRUNC (NVL (aph.last_update_date, SYSDATE))
                - TRUNC (aph.hold_date)
               ) AS days_os,
               pod.quantity_ordered AS shipment_quantity_ordered,
               pod.quantity_delivered AS shipment_quantity_delivered,
               pod.quantity_billed AS shipment_quantity_billed,
               api.invoice_received_date AS invoice_received_date,
               pob.agent_name AS buyer,
               povs.vendor_site_code AS supplier_site,
               ppf.full_name AS requestor, rcvh.receipt_num AS receipt_number,
               rcv.quantity AS received_accepted_qty,
               rcv.unit_of_measure AS uom,
               rcv.creation_date AS receipt_transacted_date,
               rcv.transaction_date AS receipt_date
          FROM apps.ap_invoices_all api,
               apps.ap_invoice_distributions_all apd,
               apps.po_distributions_all pod,
               apps.po_headers_all poh,
               apps.po_releases_all por,
               apps.po_lines_all pol,
               apps.ap_holds_all aph,
               apps.po_vendors pov,
               apps.po_agents_v pob,
               apps.po_vendor_sites_all povs,
               apps.rcv_transactions rcv,
               apps.rcv_shipment_headers rcvh,
               apps.po_line_locations_all pll,
               apps.hr_locations_all loc,
               apps.per_all_people_f ppf
         WHERE 1 = 1
           AND api.invoice_id = apd.invoice_id
           AND aph.invoice_id(+) = api.invoice_id
           AND api.vendor_id = pov.vendor_id(+)
           AND api.cancelled_date IS NULL
           AND apd.po_distribution_id = pod.po_distribution_id(+)
           AND aph.line_location_id = pod.line_location_id
           AND aph.line_location_id IS NULL
           AND poh.po_header_id(+) = pod.po_header_id
           AND por.po_release_id(+) = pod.po_release_id
           AND pol.po_header_id(+) = pod.po_header_id
           AND pol.po_line_id(+) = pod.po_line_id
           AND poh.agent_id = pob.agent_id(+)
           AND povs.vendor_site_id(+) = poh.vendor_site_id
           AND apd.po_distribution_id = rcv.po_distribution_id(+)
           AND rcvh.shipment_header_id(+) = rcv.shipment_header_id
           AND rcv.destination_type_code(+) = 'RECEIVING'
           AND pll.line_location_id(+) = pod.line_location_id
           AND pll.ship_to_location_id = loc.location_id(+)
           AND pod.deliver_to_person_id = ppf.person_id(+)
           AND NVL (ppf.effective_start_date, SYSDATE) <= SYSDATE
           AND NVL (ppf.effective_end_date, SYSDATE + 1) > SYSDATE
        UNION
        SELECT 'NON Holds - Source 3' AS SOURCE,
               apii.invoice_date AS invoice_date,
               apii.invoice_num AS invoice_num,
               pov.vendor_name AS supplier_name,
               apd.distribution_line_number AS inv_line_num,
               apd.amount AS invoice_line_amount, 'N' AS defect,
               poh.segment1 AS po_number, por.release_num AS po_release_num,
               pol.line_num AS po_line_num, NULL AS hold_date,
               NULL AS hold_lookup_code, NULL AS hold_reason,
               NULL AS release_date, 0 AS days_os,
               pod.quantity_ordered AS shipment_quantity_ordered,
               pod.quantity_delivered AS shipment_quantity_delivered,
               pod.quantity_billed AS shipment_quantity_billed,
               apii.invoice_received_date AS invoice_received_date,
               pob.agent_name AS buyer,
               povs.vendor_site_code AS supplier_site,
               ppf.full_name AS requestor, rcvh.receipt_num AS receipt_number,
               rcv.quantity AS received_accepted_qty,
               rcv.unit_of_measure AS uom,
               rcv.creation_date AS receipt_transacted_date,
               rcv.transaction_date AS receipt_date
          FROM apps.ap_invoices_all apii,
               apps.ap_invoice_distributions_all apd,
               apps.po_distributions_all pod,
               apps.po_headers_all poh,
               apps.po_releases_all por,
               apps.po_lines_all pol,
               apps.po_vendors pov,
               apps.po_agents_v pob,
               apps.po_vendor_sites_all povs,
               apps.rcv_transactions rcv,
               apps.rcv_shipment_headers rcvh,
               apps.po_line_locations_all pll,
               apps.hr_locations_all loc,
               apps.per_all_people_f ppf
         WHERE 1 = 1
           AND apii.invoice_id = apd.invoice_id
           AND apii.vendor_id = pov.vendor_id(+)
           AND apii.cancelled_date IS NULL
           AND apd.po_distribution_id = pod.po_distribution_id(+)
           AND apd.distribution_line_number NOT IN (
                  SELECT apd.distribution_line_number
                    FROM apps.ap_invoices_all api,
                         apps.ap_invoice_distributions_all apd,
                         apps.po_distributions_all pod,
                         apps.ap_holds_all aph
                   WHERE 1 = 1
                     AND api.invoice_id = apd.invoice_id
                     AND aph.invoice_id(+) = api.invoice_id
                     AND api.cancelled_date IS NULL
                     AND apd.po_distribution_id = pod.po_distribution_id(+)
                     AND aph.line_location_id = pod.line_location_id
                     AND api.invoice_id = apii.invoice_id)
           AND poh.po_header_id(+) = pod.po_header_id
           AND por.po_release_id(+) = pod.po_release_id
           AND pol.po_header_id(+) = pod.po_header_id
           AND pol.po_line_id(+) = pod.po_line_id
           AND poh.agent_id = pob.agent_id(+)
           AND povs.vendor_site_id(+) = poh.vendor_site_id
           AND apd.po_distribution_id = rcv.po_distribution_id(+)
           AND rcvh.shipment_header_id(+) = rcv.shipment_header_id
           AND rcv.destination_type_code(+) = 'RECEIVING'
           AND pll.line_location_id(+) = pod.line_location_id
           AND pll.ship_to_location_id = loc.location_id(+)
           AND pod.deliver_to_person_id = ppf.person_id(+)
           AND NVL (ppf.effective_start_date, SYSDATE) <= SYSDATE
           AND NVL (ppf.effective_end_date, SYSDATE + 1) > SYSDATE)

 WHERE invoice_num = 'YOUR INVOICE NUMBER'
