select sum(transaction_quantity) from mtl_material_transactions
inventory_item_id=&your_item
and organization_id=&organization_id
and transaction_quantity>0
and transaction_date between trunc(sysdate) and trunc(sysdate-270))