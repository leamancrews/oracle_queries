DECLARE
    xAssignID                     NUMBER;
    xReturnStatus                 VARCHAR2 ( 2000 );
    xMsgCount                     NUMBER ( 5 );
    xMsgData                      VARCHAR2 ( 2000 );
    pPayee                        IBY_DISBURSEMENT_SETUP_PUB.PAYEECONTEXT_REC_TYPE;
    pAssignmentAttribs            IBY_FNDCPT_SETUP_PUB.PMTINSTRASSIGNMENT_REC_TYPE;
    xResponse                     IBY_FNDCPT_COMMON_PUB.RESULT_REC_TYPE;
    pInstrument                   IBY_FNDCPT_SETUP_PUB.PMTINSTRUMENT_REC_TYPE;
    vInstrumentID                 NUMBER;
    vBankName                     VARCHAR2 ( 100 );
    vVendorName                   VARCHAR2 ( 100 );
    vSupplierPartyID              NUMBER;                     	 -- EXISTING SUPPLIERS/CUSTOMER PARTY_ID
    vBankID                       NUMBER;              	 -- EXISTING BANK PARTY ID
    vBankBranchID                 NUMBER;            	 -- EXISTING BRANCH PARTY ID
BEGIN
    vBankName                     := 'TEST BANK DEC99';
    vVendorName                   := 'XXAOA SUPPLIER for DEMO99';
 
    -- SELECT EXISTING Branch PARTY ID to create Branch
    BEGIN
        SELECT bank_party_id, branch_party_id
          INTO vBankID, vBankBranchID
          FROM ce_bank_branches_v
         WHERE UPPER ( bank_name ) = UPPER ( vBankName );  -- Replace with your Bank Name
    EXCEPTION
        WHEN OTHERS
        THEN
            vBankID                 := 0;
            vBankBranchID           := 0;
            DBMS_OUTPUT.put_line(     'Exception while fetching Bank Branch Details '
                                    || SQLERRM
                                );
    END;
 
    -- SELECT EXISTING Supplier
    BEGIN
        SELECT ext_bank_account_id
          INTO vInstrumentID
          FROM iby_ext_bank_accounts
         WHERE branch_id = vBankBranchID AND bank_id = vBankID;
    EXCEPTION
        WHEN OTHERS
        THEN
            vInstrumentID                  := 0;
            DBMS_OUTPUT.put_line
                                     (     'Exception while fetching Supplier Details '
                                        || SQLERRM
                                     );
    END;
 
    -- SELECT EXISTING Supplier
    BEGIN
        SELECT party_id
          INTO vSupplierPartyID
          FROM ap_suppliers
         WHERE UPPER ( vendor_name ) = UPPER ( vVendorName );    -- Replace with your Supplier Name
    EXCEPTION
        WHEN OTHERS
        THEN
            vSupplierPartyID              := 0;
            DBMS_OUTPUT.put_line
                                     (     'Exception while fetching Supplier Details '
                                        || SQLERRM
                                     );
    END;
 
    pInstrument.instrument_type    := 'BANKACCOUNT';
    pInstrument.instrument_id      := vInstrumentID;
 --<bank account id>  IBY_EXT_BANKACCT_PUB.CREATE_EXT_BANK_ACCT API account id
    pAssignmentAttribs.start_date  := SYSDATE;
    pAssignmentAttribs.instrument  := pInstrument;
    pPayee.party_id                := vSupplierPartyID;
  -- EXISTING SUPPLIERS/CUSTOMER PARTY_ID -- which is party_id of the supplier
    pPayee.payment_function        := 'PAYABLES_DISB';
    IBY_DISBURSEMENT_SETUP_PUB.SET_PAYEE_INSTR_ASSIGNMENT
                            ( p_api_version                  => 1.0
                             ,p_init_msg_list                => fnd_api.g_false
                             ,p_commit                       => fnd_api.g_true
                             ,x_return_status                => xReturnStatus
                             ,x_msg_count                    => xMsgCount
                             ,x_msg_data                     => xMsgData
                             ,p_payee                        => pPayee
                             ,p_assignment_attribs           => pAssignmentAttribs
                             ,x_assign_id                    => xAssignID
                             ,x_response                     => xResponse
                            );
    DBMS_OUTPUT.put_line ( 'xReturnStatus             :' || xReturnStatus );
    DBMS_OUTPUT.put_line ( 'xMsgCount                 :' || xMsgCount );
    DBMS_OUTPUT.put_line ( 'x_assign_id               :' || xAssignID );
    DBMS_OUTPUT.put_line ( 'xResponse.Result_Code     :' || xResponse.result_code );
    DBMS_OUTPUT.put_line ( 'xResponse.Result_Category :' || xResponse.result_category);
    DBMS_OUTPUT.put_line ( 'xResponse.Result_Message  :' || xResponse.result_message);
 
    IF xReturnStatus = 'S'
    THEN
        COMMIT;
    ELSE
        IF xMsgCount > 1
        THEN
            FOR i IN 1 .. xMsgCount
            LOOP
                DBMS_OUTPUT.put_line
                         (     i
                            || '.'
                            || SUBSTR
                                      ( fnd_msg_pub.get ( p_encoded                            => fnd_api.g_false )
                                        ,1
                                        ,255
                                      )
                         );
            END LOOP;
        END IF;
 
        ROLLBACK;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line ( 'Error..' || SQLERRM );
END;
/
SHOW ERRORS