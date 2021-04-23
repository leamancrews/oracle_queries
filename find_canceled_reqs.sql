SELECT a.AUTHORIZATION_STATUS,(a.ORG_ID),(SELECT distinct hr.per_all_people_f.first_name|| ‘ ‘|| hr.per_all_people_f.middle_names|| ‘ ‘|| hr.per_all_people_f.last_name “Employee Name”
FROM hr.per_all_people_f
where hr.per_all_people_f.PERSON_ID in
(select employee_id from fnd_user fu where fu.user_id = a.CREATED_BY)) CREATED_BY,count(SEGMENT1 )
FROM
po_requisition_headers_all a
WHERE
a.creation_date BETWEEN TO_DATE(’01/01/2007′, ‘DD/MM/YYYY’)
and TO_DATE(’30/05/2007′, ‘DD/MM/YYYY’)
and a.AUTHORIZATION_STATUS = ‘CANCELLED’
group by a.AUTHORIZATION_STATUS,a.ORG_ID,a.CREATED_BY