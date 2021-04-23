select
    fal.application_name    "Application",
    xent.name               "Entity",
    xec.name                "Event Class",
    xet.name                "Event Type",
    --
    fal.application_id,
    xent.entity_code,
    xec.event_class_code,
    xet.event_type_code
from
    fnd_application_tl fal,
    xla_entity_types_tl xent,
    xla_event_types_tl xet,
    xla_event_classes_tl xec
where
    1=1
and fal.language = userenv ('LANG')
and xent.application_id = fal.application_id
and xent.language = fal.language
and xet.application_id = xent.application_id
and xet.entity_code = xent.entity_code
and xet.language = xent.language
and xec.application_id = xet.application_id
and xec.entity_code = xet.entity_code
and xec.event_class_code = xet.event_class_code
and xec.language = xet.language
--
and fal.application_name = 'Payables'
order by
    1,2,3