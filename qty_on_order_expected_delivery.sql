select sum(ordered_quantity),a.SCHEDULE_SHIP_DATE
from oe_order_lines_all a
where inventory_item_id=10
and ship_from_org_id=188
group by a.SCHEDULE_SHIP_DATE