SELECT
	TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) as_of_date,
	-- inv.payment_schedule_id,
	xep.name legal_entity_name,
	cust.account_number,
	p.party_name account_name,
	prof.credit_limit,
	-- inv.trx_number invoice_number,
	-- rct.purchase_order customer_po_number,
	-- rctl.bol_numbers,
	-- rtt.name transaction_type,
	-- TRUNC(inv.trx_date) transaction_date,
	-- TRUNC(inv.due_date) due_date,
	-- TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) 
	-- 	- TRUNC(inv.due_date)) past_due_days,
	-- inv.amount_due_original original_balance,
	-- adj.adjusted_amount,
	-- app.received_amount,
	-- app.credited_amount,
	-- app.applied_amount,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) 
			- TRUNC(inv.due_date)) <= 0
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_current,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) 
			- TRUNC(inv.due_date)) BETWEEN 1 AND 30
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_1_to_30,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) BETWEEN 31 AND 60
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_31_to_60,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) BETWEEN 61 AND 90
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_61_to_90,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) BETWEEN 91 AND 120
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_91_to_120,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) BETWEEN 121 AND 150
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_121_to_150,
	SUM(CASE 
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) > 150
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_gt_150,
	SUM(CASE
		WHEN TO_NUMBER(TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			- TRUNC(inv.due_date)) > 90
		THEN inv.amount_due_original
			+NVL(adj.adjusted_amount, 0)
			-NVL(app.applied_amount, 0)
	END) balance_gt_90,
	SUM(inv.amount_due_original
		+NVL(adj.adjusted_amount, 0)
		-NVL(app.applied_amount, 0)) total_balance
FROM
	hz_cust_accounts cust,
	hz_parties p,
    hz_customer_profiles_f prof,
	ar_payment_schedules_all inv,
	ra_customer_trx_all rct,
	(
		SELECT customer_trx_id,
			LISTAGG(ila.interface_line_attribute1, ',') WITHIN GROUP (ORDER BY ila.rn) AS bol_numbers
		FROM (SELECT 
				customer_trx_id,
				CASE ROW_NUMBER() OVER (PARTITION BY customer_trx_id
						ORDER BY interface_line_attribute1)
					WHEN 4 THEN '...' ELSE interface_line_attribute1 
				END AS interface_line_attribute1,
				ROW_NUMBER() OVER (PARTITION BY customer_trx_id
					ORDER BY interface_line_attribute1) rn
			  FROM ra_customer_trx_lines_all
			  WHERE interface_line_attribute1 IS NOT NULL
			  GROUP BY customer_trx_id, interface_line_attribute1
			  ORDER BY customer_trx_id, interface_line_attribute1) ila
		WHERE ila.rn <= 4
		GROUP BY ila.customer_trx_id
	) rctl,
	ra_cust_trx_types_all rtt,
	xle_entity_profiles xep,
	(
		SELECT 
			aps.payment_schedule_id,
			SUM(NVL(adj.acctd_amount, 0)) adjusted_amount
		FROM
			ar_payment_schedules_all aps,
			ar_adjustments_all adj
		WHERE
			aps.customer_trx_id = adj.customer_trx_id
			AND aps.org_id = adj.org_id
			AND aps.class = 'INV'
			AND adj.status = 'A'
			AND TRUNC(adj.gl_date) <= TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
		GROUP BY aps.payment_schedule_id
	) adj,
	(
		SELECT
			ara.applied_payment_schedule_id,
			SUM(CASE
					WHEN ara.application_type = 'CASH' 
					THEN NVL(ara.amount_applied, 0)
				END) received_amount,
			SUM(CASE
					WHEN ara.application_type = 'CM'
					THEN NVL(ara.amount_applied, 0)
				END) credited_amount,
			SUM(NVL(ara.amount_applied, 0)) applied_amount
		FROM
			ar_receivable_applications_all ara
		WHERE
			ara.application_type IN ('CASH', 'CM')
			AND ara.status = 'APP'
			AND TRUNC(ara.gl_date) <= TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
			--AND NVL(ara.reversal_gl_date, 
			--	TO_DATE('9999', 'YYYY')) > TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
		GROUP BY ara.applied_payment_schedule_id
	) app
WHERE
	inv.class = 'INV'
	AND inv.customer_id = cust.cust_account_id
	AND cust.party_id = p.party_id
    AND cust.cust_account_id = prof.cust_account_id
    AND prof.site_use_id IS NULL
	AND inv.customer_trx_id = rct.customer_trx_id(+)
	AND rct.customer_trx_id = rctl.customer_trx_id(+)
	AND rct.legal_entity_id = xep.legal_entity_id(+)
	AND inv.cust_trx_type_seq_id = rtt.cust_trx_type_seq_id(+)
	AND inv.payment_schedule_id = adj.payment_schedule_id(+)
	AND inv.payment_schedule_id = app.applied_payment_schedule_id(+)
	AND TRUNC(inv.GL_DATE) <= TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
	AND xep.name IN (:P_LEGAL_ENTITY_NAME)
	AND inv.amount_due_original
		+NVL(adj.adjusted_amount, 0)
		-NVL(app.applied_amount, 0) <> 0
	AND cust.attribute2 = nvl(:P_CUSTOMER_TYPE, cust.attribute2)
GROUP BY 
	xep.name,
	cust.account_number,
	p.party_name,
	prof.credit_limit



UNION ALL

SELECT 
	TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) as_of_date,
	---1 payment_schedule_id,
	NULL legal_entity_name,
	cust.account_number,
	p.party_name account_name,
    prof.credit_limit,
	--CASE ara.status
	--	WHEN 'UNAPP' THEN 'Unapplied'
	--	WHEN 'ACC' THEN 'On-account'
	--END  invoice_number,
    --NULL customer_po_number,
	--NULL bol_numbers,
	--NULL transaction_type,
	--NULL transaction_date,
	--NULL due_date,
	--0 past_due_days,
	--0 original_balance,
	--0 adjusted_amount,
	--0 received_amount,
	--0 credited_amount,
	--SUM(NVL(ara.amount_applied, 0)) applied_amount,
	-SUM(NVL(ara.amount_applied, 0)) balance_current,
	0 balance_1_to_30,
	0 balance_31_to_60,
	0 balance_61_to_90,
	0 balance_91_to_120,
	0 balance_121_to_150,
	0 balance_gt_150,
	0 balance_gt_90,
	-SUM(NVL(ara.amount_applied, 0)) total_balance
FROM ar_receivable_applications_all ara
INNER JOIN ar_payment_schedules_all aps
	ON ara.payment_schedule_id = aps.payment_schedule_id
INNER JOIN hz_cust_accounts cust
	ON aps.customer_id = cust.cust_account_id
INNER JOIN hz_parties p
	ON p.party_id = cust.party_id
INNER JOIN hz_customer_profiles_f prof
	ON cust.cust_account_id = prof.cust_account_id
	AND prof.site_use_id IS NULL
WHERE
	ara.application_type IN ('CASH', 'CM')
	AND ara.status IN ('UNAPP', 'ACC')
	AND cust.attribute2 = nvl(:P_CUSTOMER_TYPE, cust.attribute2)
	AND TRUNC(ara.GL_DATE) <= TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
GROUP BY 
	cust.account_number,
	p.party_name,
	prof.credit_limit
	--,
	--ara.status
HAVING SUM(NVL(ara.amount_applied, 0)) <> 0

UNION ALL

SELECT
	TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4) as_of_date,
	---1 payment_schedule_id,
	NULL legal_entity_name,
	cust.account_number,
	p.party_name account_name,
    prof.credit_limit,
	--cm.trx_number invoice_number,
    --NULL customer_po_number,
	--NULL bol_numbers,
	--rtt.name transaction_type,
	--cm.trx_date transaction_date,
	--NULL due_date,
	--0 past_due_days,
	--SUM(NVL(cm.amount_due_original, 0)) original_balance,
	--0 adjusted_amount,
	--0 received_amount,
	--0 credited_amount,
	--0 applied_amount,
	SUM(NVL(cm.amount_due_original, 0)) balance_current,
	0 balance_1_to_30,
	0 balance_31_to_60,
	0 balance_61_to_90,
	0 balance_91_to_120,
	0 balance_121_to_150,
	0 balance_gt_150,
	0 balance_gt_90,
	SUM(NVL(cm.amount_due_original, 0)) total_balance	
FROM ar_payment_schedules_all cm
INNER JOIN hz_cust_accounts cust
	ON cm.customer_id = cust.cust_account_id
INNER JOIN hz_parties p
	ON p.party_id = cust.party_id
INNER JOIN hz_customer_profiles_f prof
	ON cust.cust_account_id = prof.cust_account_id
	AND prof.site_use_id IS NULL
LEFT OUTER JOIN ar_receivable_applications_all ara
	ON cm.payment_schedule_id = ara.payment_schedule_id
LEFT OUTER JOIN ra_cust_trx_types_all rtt
	ON cm.cust_trx_type_seq_id = rtt.cust_trx_type_seq_id
WHERE cm.class = 'CM'
	AND cust.attribute2 = nvl(:P_CUSTOMER_TYPE, cust.attribute2)
	AND TRUNC(cm.GL_DATE) <= TRUNC(CAST(:P_AS_OF_DATE AS DATE) + 1/4)
	AND ara.payment_schedule_id IS NULL
GROUP BY 
	cust.account_number,
	p.party_name,
	prof.credit_limit
	--,
	--cm.trx_number,
	--cm.trx_date,
	--rtt.name
HAVING SUM(NVL(cm.amount_due_original, 0)) <> 0