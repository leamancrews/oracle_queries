select
distinct RHA.requisition_number ,
PAH.OBJECT_TYPE_CODE ,
PAH.SEQUENCE_NUM ,
PAH.ACTION_CODE ,
PAH.ACTION_DATE ,
PPN.DISPLAY_NAME ,
PAH.PERFORMER_ID
 
from 
FUSION.PO_ACTION_HISTORY PAH ,
FUSION.POR_REQUISITION_HEADERS_ALL RHA ,
FUSION.PER_PERSON_NAMES_F PPN
 
where 1=1 
AND PAH.object_id = RHA.requisition_header_id
AND RHA.requisition_number IN ('ABCDEFGH')
AND PAH.PERFORMER_ID = PPN.PERSON_ID

order by PAH.SEQUENCE_NUM
