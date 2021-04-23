SELECT 
    pname.last_name, pname.first_name

FROM 
    po_agent_assignments paas,
    per_person_names_f pname

WHERE 
    EXISTS (SELECT 1
        FROM po_agent_accesses paac
        WHERE paac.assignment_id = paas.assignment_id 
        AND access_action_code = 'MANAGE_SUPPLIERS')
    AND paas.agent_id = pname.person_id

ORDER BY pname.last_name, pname.first_name

/* SELECT DISTINCT if the same person is a 
procurement agent for multiple procurement BUs */

