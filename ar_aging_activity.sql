SELECT
	TRUNC(CAST(:P_START_DATE AS DATE) + 1/4) start_date,
	TRUNC(CAST(:P_END_DATE AS DATE) + 1/4) end_date,
	inv.payment_schedule_id,
	inv.invoice_legal_entity,
	inv.customer_number,
	inv.customer_name,
	inv.invoice_number,
	inv.invoice_type,
	inv.invoice_gl_date,
	inv.invoice_date,
	inv.due_date,
	inv.original_amount,
	inv.customer_trx_number,
	--NVL(adj.starting_adjusted_amount, 0) starting_adjusted_amount,
	NVL(adj.adjusted_amount, 0) adjusted_amount,
	--NVL(adj.ending_adjusted_amount, 0) ending_adjusted_amount,
	--NVL(app.starting_applied_amount, 0) starting_applied_amount,
	NVL(app.applied_amount, 0) applied_amount,
	--NVL(app.ending_applied_amount, 0) ending_applied_amount,
	CASE 
		WHEN TRUNC(inv.invoice_gl_date) >= TRUNC(CAST(:P_START_DATE AS DATE) + 1/4) THEN 0 
		ELSE NVL(inv.original_amount, 0)
			+NVL(adj.starting_adjusted_amount, 0)
			-NVL(app.starting_applied_amount, 0) 
	END starting_amount,
	CASE
		WHEN TRUNC(inv.invoice_gl_date) < TRUNC(CAST(:P_START_DATE AS DATE) + 1/4) THEN 0
		ELSE NVL(inv.original_amount, 0)
	END invoiced_amount,
	NVL(inv.original_amount, 0)
		+NVL(adj.ending_adjusted_amount, 0)
		-NVL(app.ending_applied_amount, 0) ending_amount
FROM
	(
		SELECT 
			i.payment_schedule_id, 
			i.customer_id,
			c.account_number customer_number,
			p.party_name customer_name,
			TRUNC(i.trx_date) invoice_date, 
			TRUNC(i.gl_date) invoice_gl_date,
			TRUNC(i.due_date) due_date,
			i.amount_due_original original_amount,
			xep.name invoice_legal_entity,
			i.trx_number invoice_number,
			rtt.name invoice_type,
			rct.trx_number customer_trx_number
		FROM ar_payment_schedules_all i
			INNER JOIN hz_cust_accounts c
				ON c.cust_account_id = i.customer_id
			INNER JOIN hz_parties p
				ON c.party_id = p.party_id
			LEFT OUTER JOIN ra_customer_trx_all rct
				ON i.customer_trx_id = rct.customer_trx_id
			LEFT OUTER JOIN xle_entity_profiles xep
				ON rct.legal_entity_id = xep.legal_entity_id
			LEFT OUTER JOIN ra_cust_trx_types_all rtt
				ON i.cust_trx_type_seq_id = rtt.cust_trx_type_seq_id
		WHERE i.class = 'INV'
			AND TRUNC(i.gl_date) <= TRUNC(CAST(:P_END_DATE AS DATE) + 1/4)
			AND xep.name IN (:P_LEGAL_ENTITY_NAME)
		UNION ALL 
		SELECT 
			-999 payment_schedule_id,
			c.cust_account_id customer_id,
			c.account_number customer_number,
			p.party_name customer_name,
			NULL invoice_gl_date,
			NULL invoice_date,
			NULL due_date,
			0 original_amount,
			'NA' invoice_legal_entity,
			'No Invoice' invoice_number,
			'NA' invoice_type,
			'NA' customer_trx_number
		FROM hz_cust_accounts c
		INNER JOIN hz_parties p
			ON c.party_id = p.party_id
	) inv
	LEFT OUTER JOIN (
		SELECT 
			aps.payment_schedule_id,
			SUM(CASE 
					WHEN adj.gl_date 
						< TRUNC(CAST(:P_START_DATE AS DATE) + 1/4)
					THEN NVL(adj.acctd_amount, 0)
				END) starting_adjusted_amount,
			SUM(CASE
					WHEN adj.gl_date 
						>= TRUNC(CAST(:P_START_DATE AS DATE) + 1/4)
					THEN NVL(adj.acctd_amount, 0)
				END) adjusted_amount,
			SUM(NVL(adj.acctd_amount, 0)) ending_adjusted_amount
		FROM
			ar_payment_schedules_all aps
			INNER JOIN ar_adjustments_all adj
				ON aps.customer_trx_id = adj.customer_trx_id
				AND aps.org_id = adj.org_id
		WHERE
			aps.class = 'INV'
			AND adj.status = 'A'
			AND TRUNC(adj.gl_date) 
				<= TRUNC(CAST(:P_END_DATE AS DATE) + 1/4)
		GROUP BY aps.payment_schedule_id
	) adj ON adj.payment_schedule_id 
			= inv.payment_schedule_id
	LEFT OUTER JOIN (
		SELECT
			NVL(ara.applied_payment_schedule_id, -999) 
				applied_payment_schedule_id,
			NVL(apl.customer_id, aps.customer_id) customer_id,
			SUM(CASE
					WHEN TRUNC(ara.gl_date) 
							< TRUNC(CAST(:P_START_DATE AS DATE) + 1/4)
					THEN NVL(ara.amount_applied, 0)
				END) starting_applied_amount,
			SUM(CASE
					WHEN TRUNC(ara.gl_date) 
						>= TRUNC(CAST(:P_START_DATE AS DATE) + 1/4)
					THEN NVL(ara.amount_applied, 0)
				END) applied_amount,
			SUM(NVL(ara.amount_applied, 0)) ending_applied_amount
		FROM
			ar_receivable_applications_all ara
			INNER JOIN ar_payment_schedules_all aps
				ON ara.payment_schedule_id 
					= aps.payment_schedule_id
			LEFT OUTER JOIN ar_payment_schedules_all apl
				ON ara.applied_payment_schedule_id 
					= apl.payment_schedule_id
		WHERE
			TRUNC(ara.gl_date) 
				<= TRUNC(CAST(:P_END_DATE AS DATE) + 1/4)
		GROUP BY ara.applied_payment_schedule_id,
			NVL(apl.customer_id, aps.customer_id)
	) app 
		ON app.applied_payment_schedule_id 
			= inv.payment_schedule_id
		AND app.customer_id = inv.customer_id
WHERE 
	NVL(inv.original_amount, 0)
		+NVL(adj.starting_adjusted_amount, 0)
		-NVL(app.starting_applied_amount, 0) <> 0
	OR adj.adjusted_amount <> 0
	OR app.applied_amount <> 0
	OR NVL(inv.original_amount, 0)
		+NVL(adj.ending_adjusted_amount, 0)
		-NVL(app.ending_applied_amount, 0) <> 0
ORDER BY invoice_date desc, invoice_number