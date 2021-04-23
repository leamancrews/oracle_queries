REM $Header: ap_remtchdist_cnclinv_sel.sql 120.0 2013/06/13 06:54:34 rnimmaka noship $
REM +=========================================================================+
REM |                Copyright (c) 2013 Oracle Corporation
REM |                   Redwood Shores, California, USA
REM |                        All rights reserved.
REM +=========================================================================+
REM |  Name 
REM |       ap_remtchdist_cnclinv_sel.sql
REM | 
REM |  Issue Detail: 
REM |      Cancelled invoice can be rematched if we change the match option
REM |  
REM |  Script Type:
REM |       Selection
REM |
REM |  RCA Bug(s):
REM |       16841130 
REM |
REM |  Datafix Type:
REM |       Onetime fix(RCA is available)
REM |  
REM |
REM |  Functional Impact :
REM |       Shows as partial accounted.
REM |
REM |
REM |
REM |  CrossProduct Impact :
REM |
REM |      NA
REM |
REM |
REM |  List of steps/verification before datafix:
REM |       Verify the data in driver table
REM |  
REM |  List of steps/verification after datafix:
REM |       Apply GDF 10277949(Follow instructions mentioned in
REM |       Metalink Note 982072.1)
REM |       Apply RCA fix 16841130 to avoid further corruption of data.
REM |  
REM |  Instructions to run this script:
REM |       1.This is selection script that will create the driver table
REM |         ap_remtch_hdr_cancel_invs
REM |       2.Review the data in the driver table and update the process_flag
REM |         to 'Y' in the driver table ap_remtch_hdr_cancel_invs for invoices
REM |         that need to be fixed.
REM |   Note: By default process_flag will be 'N' in the driver table.
REM |  
REM |  Version History:
REM |       Created MKMEDA 21-May-2013      
REM |
REM |
REM +=========================================================================+

Begin

Begin
EXECUTE IMMEDIATE 'drop table ap_remtch_dist_cancel_invs';
exception
   when others then
       null;
End;

Begin
EXECUTE IMMEDIATE 'drop table ap_remtch_hdr_cancel_invs';
exception
   when others then
       null;
End;

Begin
EXECUTE IMMEDIATE 'drop table ap_remtch_line_cancel_invs';
exception
   when others then
       null;
End;

End;
/
CREATE TABLE ap_remtch_dist_cancel_invs AS
SELECT aid.*
FROM   ap_invoices_all ai,
       ap_invoice_distributions_all aid
WHERE  ai.cancelled_date is not null
AND    aid.invoice_id = ai.invoice_id
AND    aid.creation_date > ai.cancelled_date
AND    aid.po_distribution_id is not null
AND    aid.accounting_event_id is null;


CREATE TABLE ap_remtch_line_cancel_invs AS
SELECT ail.*
FROM   ap_invoice_lines_all ail
WHERE (ail.invoice_id,ail.line_number) IN
      (SELECT a.invoice_id,
              a.invoice_line_number
       FROM   ap_remtch_dist_cancel_invs a);

	   
CREATE TABLE ap_remtch_hdr_cancel_invs AS
SELECT ai.invoice_id,
       'N' process_flag
FROM   ap_invoices_all ai
WHERE  ai.invoice_id in (SELECT a.invoice_id 
                         FROM   ap_remtch_dist_cancel_invs a);   


Commit;