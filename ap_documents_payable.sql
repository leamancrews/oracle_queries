SELECT
  pay_proc_trxn_type_code,
  calling_app_doc_unique_ref1 check_id,
  calling_app_doc_unique_ref2 invoice_id,
  calling_app_doc_unique_ref4 invoice_payment_id,
  calling_app_doc_ref_number invoice_number,
  payment_function,
  payment_date,
  document_date,
  document_type,
  payment_currency_code,
  payment_amount,
  payment_method_code
FROM    AP_DOCUMENTS_PAYABLE
WHERE calling_app_id              = 200
AND   calling_app_doc_unique_ref2 = '124567'; 
