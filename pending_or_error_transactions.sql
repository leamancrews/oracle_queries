SELECT transaction_id
      ,consumption_processed_flag
      ,ERROR_CODE
      ,net_qty
      ,batch_id
      ,creation_date
      ,consumption_release_id
      ,consumption_po_header_id
 FROM mtl_consumption_transactions
WHERE consumption_processed_flag IN ('E', 'N');