select 
	INVENTORY_ITEM_ID,
	ORGANIZATION_ID,
	CREATION_DATE,
	DESCRIPTION,
	LAST_UPDATE_DATE,
	PURCHASING_ITEM_FLAG,
	CUSTOMER_ORDER_FLAG,
	INTERNAL_ORDER_FLAG,
	INVENTORY_ITEM_FLAG,
	INVENTORY_ASSET_FLAG,
	MTL_TRANSACTIONS_ENABLED_FLAG,
	SOURCE_SUBINVENTORY,
	LONG_DESCRIPTION
from
	EGP_SYSTEM_ITEMS