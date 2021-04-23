SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1';SELECT
   0 s_0,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Include Intercompany Transactions" s_1,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Include On Account Items" s_2,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Include Unapplied and Unidentified Receipts" s_3,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Last Updated Date" s_4,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Ledger" s_5,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Period" s_6,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Request Key" s_7,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."- Receivables to Ledger Reconciliation Request"."Request Name" s_8,
   "Subledger Accounting - Receivables Summary Reconciliation Real Time"."Business Unit"."Business Unit Name" s_9,
   '' s_10,
   DESCRIPTOR_IDOF("Subledger Accounting - Receivables Summary Reconciliation Real Time"."Business Unit"."Business Unit Name") s_11
FROM "Subledger Accounting - Receivables Summary Reconciliation Real Time"
WHERE
(("Business Unit"."Business Unit Name" IS NOT NULL) AND ("- Receivables to Ledger Reconciliation Request"."Ledger" IN ('p_ledger')))
ORDER BY 1, 11 ASC NULLS LAST, 8 ASC NULLS LAST, 5 ASC NULLS LAST, 6 ASC NULLS LAST, 7 ASC NULLS LAST, 2 ASC NULLS LAST, 3 ASC NULLS LAST, 4 ASC NULLS LAST, 10 ASC NULLS LAST, 12 ASC NULLS LAST
FETCH FIRST 75001 ROWS ONLY

