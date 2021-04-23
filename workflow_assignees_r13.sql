SELECT
                wft.CREATEDDATE as "TASK_CREATION_DATE",
                wft.UPDATEDDATE as "TASK_LAST_UPDATE_DATE",
                wft.STATE as "TASK_STATE",
                wft.OUTCOME AS "TASK_OUTCOME",
                wfa.ASSIGNEE as "TASK_ASSIGNEE",
                wft.creator as "CREATED_BY",
                wft.IDENTIFICATIONKEY as "INVOICE_ID",
                i.INVOICE_NUM as "INVOICE_NUM"

FROM
                  FA_FUSION_SOAINFRA.WFTASK wft,
                  FA_FUSION_SOAINFRA.WFASSIGNEE wfa,
                  FUSION.AP_INVOICES_ALL i

WHERE 1=1
                 AND    wfa.TASKID = wft.TASKID
                 AND    wft.ASSIGNEES is not null
                 AND    wft.componentname     IN ('FinApInvoiceApprovalErrorFyi', 'FinApInvoiceApproval')
                 AND    wft.IDENTIFICATIONKEY = to_char(i.invoice_id)
                 --AND    i.invoice_num like :P_INVOICE_NUM
                 --and  wft.state = 'ASSIGNED'

ORDER BY 1 desc

