WITH sawith0
     AS (SELECT T289191.c80153046  AS c5,
                T289191.c160061905 AS c6,
                T289191.c501685814 AS c7,
                T289191.c428266416 AS c8,
                T289191.c252154447 AS c9,
                T289191.c51067786  AS c10,
                T289191.c379200345 AS c11,
                T289191.c432521065 AS c13,
                T289191.c105515184 AS c15,
                T289191.c39709536  AS c17,
                T289191.c388238603 AS c18
         FROM   (SELECT V239932362.last_update_date            AS C80153046,
                        V313581056.name496                     AS C160061905,
                        V239932362.period_name                 AS C501685814,
                        V239932362.request_id                  AS C428266416,
                        V239932362.request_name                AS C252154447,
                        V220364535.name                        AS C51067786,
                        V220364535.organization_id1            AS C379200345,
                        V239932362.include_intercompany_trx    AS C432521065,
                        V239932362.include_on_account_item     AS C105515184,
                        V239932362.include_unapp_unid_receipts AS C39709536,
                        V128198371.ar_acctd_amount             AS C388238603,
                        V128198371.recon_item_id               AS
                        PKA_ReconItemId0,
                        V220364535.effective_start_date651     AS
                        PKA_BusinessUnitDateFrom0,
                        V220364535.effective_end_date8         AS
                        PKA_BusinessUnitDateTo0,
                        V220364535.organization_id             AS
                        PKA_OrganizationUnitTranslati0
                                ,
                        V220364535.effective_start_date        AS
                                PKA_OrganizationUnitTranslati1,
                        V220364535.effective_end_date          AS
                        PKA_OrganizationUnitTranslati2
                                ,
                        V220364535.LANGUAGE                    AS
                                PKA_OrganizationUnitTranslati3,
                        V239932362.recon_summary_param_id      AS
                        PKA_ReconSummaryParamId0,
                        V313581056.ledger_id                   AS PKA_LedgerId0
                 FROM   (SELECT ReconciliationSummaryPEO.ar_acctd_amount,
                                ReconciliationSummaryPEO.bu_id,
                                ReconciliationSummaryPEO.recon_item_id,
                                ReconciliationSummaryPEO.request_id
                         FROM   ar_recon_summary_details
                                ReconciliationSummaryPEO,
                                gl_ledgers Ledgers
                         WHERE  ( ReconciliationSummaryPEO.ledger_id =
                                Ledgers.ledger_id )
                                AND (( EXISTS (SELECT NULL
                                               FROM   fnd_grants gnt
                                               WHERE  EXISTS (
                                              SELECT
     /*+ index(fnd_session_role_sets FND_SESSION_ROLE_SETS_U1) no_unnest */
                                              NULL
                                                              FROM
                                                      fnd_session_role_sets
                                                              WHERE
                                                      session_role_set_key =
                fnd_global.session_role_set_key
                AND role_guid = gnt.grantee_key
                UNION ALL
                SELECT fnd_global.user_guid AS path
                FROM   dual
                WHERE  fnd_global.user_guid =
                gnt.grantee_key)
                AND EXISTS (SELECT /*+ no_unnest */ NULL
                FROM   fnd_compiled_menu_functions cmf
                WHERE  cmf.function_id =
                    300000000010765
                    AND cmf.menu_id = gnt.menu_id)
                AND gnt.object_id = 300000000009108
                AND gnt.grant_type = 'ALLOW'
                AND gnt.instance_type = 'SET'
                AND gnt.start_date <= SYSDATE
                AND ( gnt.end_date IS NULL
                OR gnt.end_date >= SYSDATE )
                AND ( gnt.instance_set_id = 300000006007003
                AND Ledgers.ledger_id IN (SELECT
                primary_ledger_id
                                 FROM
                fun_all_business_units_v BU,
                fun_user_role_data_asgnmnts URDA
                                 WHERE
                BU.bu_id = URDA.org_id
                AND user_guid =
                fnd_global.user_guid
                AND role_name =
                GNT.role_name
                AND active_flag != 'N')
                )) ))) V128198371,
                (SELECT OrganizationUnit.organization_id      AS
                        ORGANIZATION_ID1,
                OrganizationUnit.effective_start_date AS EFFECTIVE_START_DATE651
                        ,
                OrganizationUnit.effective_end_date
                        AS EFFECTIVE_END_DATE8,
                OrganizationInformation.org_information_id,
                OrganizationUnitTranslation.name,
                OrganizationUnitTranslation.organization_id,
                OrganizationUnitTranslation.effective_start_date,
                OrganizationUnitTranslation.effective_end_date,
                OrganizationUnitTranslation.LANGUAGE
                FROM   hr_all_organization_units_f OrganizationUnit,
                hr_organization_information_f OrganizationInformation,
                hr_organization_units_f_tl OrganizationUnitTranslation
                WHERE  OrganizationUnit.organization_id =
                OrganizationInformation.organization_id
                AND ( 'FUN_BUSINESS_UNIT' ) =
                OrganizationInformation.org_information_context
                AND OrganizationUnit.organization_id =
                OrganizationUnitTranslation.organization_id
                AND OrganizationUnit.effective_start_date =
                OrganizationUnitTranslation.effective_start_date
                AND OrganizationUnit.effective_end_date =
                OrganizationUnitTranslation.effective_end_date
                AND ( Userenv('LANG') ) = OrganizationUnitTranslation.LANGUAGE
                AND ( DATE'2018-07-03' BETWEEN
                      OrganizationUnit.effective_start_date
                      AND
                OrganizationUnit.effective_end_date )
                AND ( DATE'2018-07-03' BETWEEN
                OrganizationInformation.effective_start_date AND
                OrganizationInformation.effective_end_date )
                AND ( DATE'2018-07-03' BETWEEN
                OrganizationUnitTranslation.effective_start_date AND
                OrganizationUnitTranslation.effective_end_date )) V220364535,
                (SELECT ReconParam.include_intercompany_trx,
                ReconParam.include_on_account_item,
                ReconParam.include_unapp_unid_receipts,
                ReconParam.last_update_date,
                ReconParam.ledger_id,
                ReconParam.period_name,
                ReconParam.recon_summary_param_id,
                ReconParam.request_id,
                ReconParam.request_name
                FROM   ar_recon_summary_parameters ReconParam) V239932362,
                (SELECT Ledger.ledger_id,
                Ledger.name AS NAME496
                FROM   gl_ledgers Ledger
                WHERE  (( Ledger.object_type_code = 'L' ))) V313581056
                 WHERE  V128198371.bu_id = V220364535.organization_id1(+)
                        AND V128198371.request_id = V239932362.request_id
                        AND V239932362.ledger_id = V313581056.ledger_id
                        AND ( (( V313581056.name496 = 'Propak' ))
                              AND (( V239932362.request_name = 'May-18_Run1' ))
                              AND ( NOT (( V220364535.name IS NULL )) ) ))
                T289191),
     sawith1
     AS (SELECT SUM(D1.c18) AS c1,
                D1.c5       AS c5,
                D1.c6       AS c6,
                D1.c7       AS c7,
                D1.c8       AS c8,
                D1.c9       AS c9,
                D1.c10      AS c10,
                D1.c11      AS c11,
                D1.c13      AS c13,
                D1.c15      AS c15,
                D1.c17      AS c17
         FROM   sawith0 D1
         WHERE  ( D1.c10 IS NOT NULL )
         GROUP  BY D1.c5,
                   D1.c6,
                   D1.c7,
                   D1.c8,
                   D1.c9,
                   D1.c10,
                   D1.c11,
                   D1.c13,
                   D1.c15,
                   D1.c17),
     sawith2
     AS (SELECT T289192.c389230568 AS c1,
                T289192.c164164071 AS c2
         FROM   (SELECT V72673585.meaning             AS C389230568,
                        V72673585.lookup_code         AS C164164071,
                        V72673585.LANGUAGE            AS C343259318,
                        V72673585.set_id              AS C497682495,
                        V72673585.lookup_type         AS C417433804,
                        V72673585.view_application_id AS C456636657
                 FROM   fnd_lookup_values_tl V72673585
                 WHERE  ( (( V72673585.lookup_type = 'AR_RECON_INT_PARAM' ))
                          AND (( V72673585.view_application_id = 222 ))
                          AND (( V72673585.set_id = 0 ))
                          AND (( V72673585.LANGUAGE = 'US' )) )) T289192),
     obicommon0
     AS (SELECT T289193.c389230568 AS c1,
                T289193.c164164071 AS c2
         FROM   (SELECT V72673585.meaning             AS C389230568,
                        V72673585.lookup_code         AS C164164071,
                        V72673585.LANGUAGE            AS C343259318,
                        V72673585.set_id              AS C497682495,
                        V72673585.lookup_type         AS C417433804,
                        V72673585.view_application_id AS C456636657
                 FROM   fnd_lookup_values_tl V72673585
                 WHERE  ( (( V72673585.lookup_type = 'YES_NO' ))
                          AND (( V72673585.view_application_id = 260 ))
                          AND (( V72673585.set_id = 0 ))
                          AND (( V72673585.LANGUAGE = 'US' )) )) T289193),
     sawith3
     AS (SELECT D2.c1  AS c2,
                D1.c13 AS c3,
                D3.c1  AS c4,
                D1.c15 AS c5,
                D4.c1  AS c6,
                D1.c17 AS c7,
                D1.c5  AS c8,
                D1.c6  AS c9,
                D1.c7  AS c10,
                D1.c8  AS c11,
                D1.c9  AS c12,
                D1.c10 AS c13,
                D1.c11 AS c14
         FROM   ( ( sawith1 D1
                    left outer join sawith2 D2
                                 ON D1.c13 = D2.c2)
                  left outer join obicommon0 D3
                               ON D1.c15 = D3.c2)
                left outer join obicommon0 D4
                             ON D1.c17 = D4.c2),
     sawith4
     AS (SELECT Nvl(D901.c2, D901.c3) AS c2,
                Nvl(D901.c4, D901.c5) AS c3,
                Nvl(D901.c6, D901.c7) AS c4,
                D901.c8               AS c5,
                D901.c9               AS c6,
                D901.c10              AS c7,
                D901.c11              AS c8,
                D901.c12              AS c9,
                D901.c13              AS c10,
                D901.c14              AS c11
         FROM   sawith3 D901)
SELECT D1.c1  AS c1,
       D1.c2  AS c2,
       D1.c3  AS c3,
       D1.c4  AS c4,
       D1.c5  AS c5,
       D1.c6  AS c6,
       D1.c7  AS c7,
       D1.c8  AS c8,
       D1.c9  AS c9,
       D1.c10 AS c10,
       D1.c11 AS c11,
       D1.c12 AS c12
FROM   (SELECT DISTINCT 0      AS c1,
                        D1.c2  AS c2,
                        D1.c3  AS c3,
                        D1.c4  AS c4,
                        D1.c5  AS c5,
                        D1.c6  AS c6,
                        D1.c7  AS c7,
                        D1.c8  AS c8,
                        D1.c9  AS c9,
                        D1.c10 AS c10,
                        ''     AS c11,
                        D1.c11 AS c12
        FROM   sawith4 D1
        ORDER  BY c8,
                  c5,
                  c6,
                  c7,
                  c2,
                  c3,
                  c4,
                  c10,
                  c12) D1
WHERE  ROWNUM <= 75001 