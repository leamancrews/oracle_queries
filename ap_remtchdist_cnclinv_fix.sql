REM $Header: ap_remtchdist_cnclinv_fix.sql 120.0 2013/06/13 06:56:18 rnimmaka noship $
REM +=========================================================================+
REM |                Copyright (c) 2013 Oracle Corporation
REM |                   Redwood Shores, California, USA
REM |                        All rights reserved.
REM +=========================================================================+
REM |  Name 
REM |       ap_remtchdist_cnclinv_fix.sql
REM | 
REM |  Issue Detail: 
REM |      Cancelled invoice can be rematched if we change the match option
REM |  
REM |  Script Type:
REM |       Fix
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
REM |       1.This is fix script that will fix the records in driver table
REM |         ap_remtch_hdr_cancel_invs having process_flag = 'Y'.
REM |       2.Ensure that you have updated the process_flag
REM |         to 'Y' in the driver table ap_remtch_hdr_cancel_invs for invoices
REM |         that need to be fixed before running this script.
REM |   Note: By default process_flag will be 'N' in the driver table.
REM |  
REM |  Version History:
REM |       Created MKMEDA 21-May-2013      
REM |
REM |
REM +=========================================================================+


SET SERVEROUTPUT ON SIZE 1000000;
BEGIN

BEGIN

EXECUTE IMMEDIATE 'CREATE TABLE ail_16841130_bkp AS
                   SELECT * 
		   FROM   ap_invoice_lines_all
		   WHERE  1 = 2';

EXECUTE IMMEDIATE 'CREATE TABLE aid_16841130_bkp AS
                   SELECT * 
		   FROM   ap_invoice_distributions_all
		   WHERE  1 = 2';

EXCEPTION
  WHEN OTHERS THEN
      NULL;
END;

EXECUTE IMMEDIATE 'INSERT INTO ail_16841130_bkp
                   (SELECT *
	            FROM   ap_invoice_lines_all ail
	            WHERE  ail.invoice_id in (SELECT invoice_id
	                                      FROM  ap_remtch_hdr_cancel_invs
		                              WHERE process_flag = ''Y''))';

EXECUTE IMMEDIATE 'INSERT INTO aid_16841130_bkp
                   (SELECT *
	            FROM   ap_invoice_distributions_all aid
	            WHERE  aid.invoice_id in (SELECT invoice_id
	                                      FROM  ap_remtch_hdr_cancel_invs
			            	      WHERE process_flag = ''Y''))';


delete from ap_invoice_lines_all ail
where (ail.invoice_id,ail.line_number) in
(select a.invoice_id,a.line_number
       from ap_remtch_line_cancel_invs a, ap_remtch_hdr_cancel_invs b
	   where a.invoice_id = b.invoice_id
	   and   b.process_flag = 'Y');

delete from ap_invoice_distributions_all aid
where (aid.invoice_id,aid.invoice_distribution_id) in
(select a.invoice_id,a.invoice_distribution_id
       from ap_remtch_dist_cancel_invs a, ap_remtch_hdr_cancel_invs b
	   where a.invoice_id = b.invoice_id
	   and   b.process_flag = 'Y');

UPDATE ap_remtch_hdr_cancel_invs
SET    process_flag = 'D'
WHERE  process_flag = 'Y';

commit;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.Put_Line(SQLERRM||' -Caught in exception');
END;