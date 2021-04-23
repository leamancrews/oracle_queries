select
    s.segment1                              "Supplier Number",
    hps.party_site_name                     "Address Name",
    hz_format_pub.format_address(
        hl.location_id, null,
        null, ', ', null,
        null, null, null)                   "Address",
    hl.country                              "Country",
    hps.identifying_address_flag            "Identifying Flag",
    hz_utility_v2pub.get_all_purposes(hps.party_site_id)    "Purpose",
    hps.status                              "Status",
    --
    s.vendor_id,
    hp.party_id,
    hps.party_site_id,
    hl.location_id
from  
    ap_suppliers s,
    hz_parties hp,
    hz_party_sites hps,
    hz_locations hl
where
    1=1
and hp.party_id = s.party_id
and hps.party_id = hp.party_id
and hl.location_id = hps.location_id
--
and s.segment1 = '1008'
order by
    1,2,3,4