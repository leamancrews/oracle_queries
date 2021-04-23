SELECT
  amount_remaining,
  batch_id,
  due_date,
  gross_amount,
  hold_flag,
  invoice_id,
  payment_num,
  SUBSTR (payment_status_flag, 1, 1) payment_status_flag,
  org_id
FROM    AP_PAYMENT_SCHEDULES_ALL
WHERE   invoice_id = '124567'; 