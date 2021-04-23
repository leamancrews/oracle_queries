SELECT FINAL."ENTITY_CODE",
       FINAL."GL Period Name",
       FINAL."GL Creation Date",
       FINAL."POSTED_DATE",
       FINAL."EFFECTIVE_DATE",
       FINAL."STATUS",
       FINAL."AE_HEADER_ID",
       FINAL."AE_LINE_NUM",
       FINAL."JE_HEADER_ID",
       FINAL."JE_LINE_NUM",
       FINAL."JE Header Name",
       FINAL."CURRENCY_CODE",
       FINAL."Functional Currency Code",
       FINAL."Document Number",
       FINAL."LEDGER_ID",
       FINAL."Ledger Name",
       FINAL."JE_CATEGORY",
       FINAL."JE_SOURCE",
       FINAL."Line Description",
       FINAL."JE_BATCH_ID",
       FINAL."Batch Name",
       FINAL."Batch Description",
       FINAL."CREATE_BY",
       FINAL."UPDATE_BY",
       FINAL."CODE_COMBINATION_ID",
       FINAL."Entered DR in SLA",
       FINAL."Entered CR in SLA",
       FINAL."Accounted DR in SLA",
       FINAL."Accounted CR in SLA",
       FINAL."Entered DR in GL",
       FINAL."Entered CR in GL",
       FINAL."Accounted DR in GL",
       FINAL."Accounted CR in GL",
       FINAL."Accounting Class",
       FINAL."Business Unit",
       FINAL."Location",
       FINAL."Department",
       FINAL."Natural Account",
       FINAL."Product Group",
       FINAL."Intercompany",
       FINAL."Future Use",
       FINAL."REFERENCE1",
       FINAL."REFERENCE2",
       FINAL."REFERENCE3",
       FINAL."REFERENCE4",
       FINAL."REFERENCE5",
       FINAL."REFERENCE6",
       FINAL."REFERENCE7",
       FINAL."REFERENCE8",
       FINAL."REFERENCE9",
       FINAL."ORGANIZATION_ID",
       FINAL."Organization Name",
       FINAL."APPLICATION_ID",
       FINAL."Application Name",
       (SELECT FLV.DESCRIPTION
          FROM APPS.FND_FLEX_VALUES_VL FLV, APPS.FND_FLEX_VALUE_SETS FLS
         WHERE     FLV.FLEX_VALUE = FINAL."Natural Account"
               AND FLV.FLEX_VALUE_SET_ID = FLS.FLEX_VALUE_SET_ID
               AND FLS.FLEX_VALUE_SET_NAME = 'XXGL_NATURAL_ACCOUNT')
           ACCOUNT_DESCRIPTION,
       (SELECT MEANING
          FROM APPS.GL_LOOKUPS
         WHERE LOOKUP_TYPE = 'BATCH_STATUS' AND LOOKUP_CODE = FINAL.STATUS)
           JE_STATUS,
       (SELECT USER_NAME
          FROM APPS.FND_USER
         WHERE USER_ID = FINAL.CREATE_BY)
           CREATED_BY,
       (SELECT USER_NAME
          FROM APPS.FND_USER
         WHERE USER_ID = FINAL.UPDATE_BY)
           LAST_UPDATED_BY
  FROM (SELECT XTEU.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               GJH.CREATION_DATE
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY
                   CREATE_BY,
               GJL.LAST_UPDATED_BY
                   UPDATE_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Company",
               GLCC.SEGMENT2
                   "Natural Account",
               GLCC.SEGMENT3
                   "Division",
               GLCC.SEGMENT4
                   "Site",
               GLCC.SEGMENT5
                   "Future",
              
               TO_CHAR (AIA.INVOICE_NUM)
                   REFERENCE1,
               AIA.SOURCE
                   REFERENCE2,
               TO_CHAR (AIA.INVOICE_TYPE_LOOKUP_CODE)
                   REFERENCE3,
               TO_CHAR (APS.SEGMENT1)
                   REFERENCE4,
               APS.VENDOR_NAME
                   REFERENCE5,
               ASSA.COUNTRY
                   REFERENCE6,
               (SELECT FLV.MEANING
                  FROM APPS.FND_LOOKUP_VALUES FLV
                 WHERE     FLV.LOOKUP_TYPE = 'VENDOR TYPE'
                       AND FLV.LANGUAGE = USERENV ('LANG')
                       AND APS.VENDOR_TYPE_LOOKUP_CODE = FLV.LOOKUP_CODE)
                   REFERENCE7,
               AIA.DESCRIPTION
                   REFERENCE8,
               NULL
                   REFERENCE9,
               HOU.ORGANIZATION_ID,
               HOU.NAME
                   "Organization Name",
               XTEU.APPLICATION_ID,
               FAT.APPLICATION_NAME
                   "Application Name"
          FROM APPS.AP_INVOICES_ALL           AIA,
               APPS.AP_SUPPLIERS              APS,
               APPS.AP_SUPPLIER_SITES_ALL     ASSA,
               APPS.HR_OPERATING_UNITS        HOU,
               XLA.XLA_TRANSACTION_ENTITIES#  XTEU,
               APPS.XLA_AE_HEADERS            XAH,
               APPS.XLA_AE_LINES              XAL,
               APPS.GL_IMPORT_REFERENCES      GIR,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_JE_BATCHES             GJB,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               APPS.FND_APPLICATION_TL        FAT
         WHERE     AIA.VENDOR_ID = APS.VENDOR_ID
               AND AIA.VENDOR_ID = ASSA.VENDOR_ID
               AND AIA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
               AND AIA.ORG_ID = HOU.ORGANIZATION_ID
               AND XTEU.ENTITY_CODE = 'AP_INVOICES'
               AND XTEU.APPLICATION_ID = 200
               AND XTEU.SOURCE_ID_INT_1 = AIA.INVOICE_ID
               AND XTEU.ENTITY_ID = XAH.ENTITY_ID
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND XAL.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTEU.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               GJH.CREATION_DATE
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               TO_CHAR (ACA.CHECK_NUMBER)
                   REFERENCE1,
               ACA.CHECKRUN_NAME
                   REFERENCE2,
               TO_CHAR (ACA.DOC_CATEGORY_CODE)
                   REFERENCE3,
               TO_CHAR (APS.SEGMENT1)
                   REFERENCE4,
               APS.VENDOR_NAME
                   REFERENCE5,
               ASSA.COUNTRY
                   REFERENCE6,
               (SELECT FLV.MEANING
                  FROM APPS.FND_LOOKUP_VALUES FLV
                 WHERE     FLV.LOOKUP_TYPE = 'VENDOR TYPE'
                       AND FLV.LANGUAGE = USERENV ('LANG')
                       AND APS.VENDOR_TYPE_LOOKUP_CODE = FLV.LOOKUP_CODE)
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               HOU.ORGANIZATION_ID,
               HOU.NAME
                   "Organization Name",
               XTEU.APPLICATION_ID,
               FAT.APPLICATION_NAME
                   "Application Name"
          FROM APPS.AP_CHECKS_ALL             ACA,
               APPS.AP_SUPPLIERS              APS,
               APPS.AP_SUPPLIER_SITES_ALL     ASSA,
               APPS.HR_OPERATING_UNITS        HOU,
               XLA.XLA_TRANSACTION_ENTITIES#  XTEU,
               APPS.XLA_AE_HEADERS            XAH,
               APPS.XLA_AE_LINES              XAL,
               APPS.GL_IMPORT_REFERENCES      GIR,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_BATCHES             GJB,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               APPS.FND_APPLICATION_TL        FAT
         WHERE     ACA.VENDOR_ID = APS.VENDOR_ID
               AND APS.VENDOR_ID = ASSA.VENDOR_ID
               AND ACA.VENDOR_SITE_ID = ASSA.VENDOR_SITE_ID
               AND ACA.ORG_ID = HOU.ORGANIZATION_ID
               AND XTEU.ENTITY_CODE = 'AP_PAYMENTS'
               AND XTEU.APPLICATION_ID = 200
               AND XTEU.SOURCE_ID_INT_1 = ACA.CHECK_ID
               AND XTEU.ENTITY_ID = XAH.ENTITY_ID
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND XAL.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTEU.ENTITY_CODE,
               GJH.PERIOD_NAME               "GL Period Name",
               GJH.CREATION_DATE             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                      "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE              "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE        "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                       "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION               "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                      "Batch Name",
               GJB.DESCRIPTION               "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                "Entered DR in SLA",
               XAL.ENTERED_CR                "Entered CR in SLA",
               XAL.ACCOUNTED_DR              "Accounted DR in SLA",
               XAL.ACCOUNTED_CR              "Accounted CR in SLA",
               GJL.ENTERED_DR                "Entered DR in GL",
               GJL.ENTERED_CR                "Entered CR in GL",
               GJL.ACCOUNTED_DR              "Accounted DR in GL",
               GJL.ACCOUNTED_CR              "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE     "Accounting Class",
               GLCC.SEGMENT1                 "Business Unit",
               GLCC.SEGMENT2                 "Location",
               GLCC.SEGMENT3                 "Department",
               GLCC.SEGMENT4                 "Natural Account",
               GLCC.SEGMENT5                 "Product Group",
               GLCC.SEGMENT6                 "Intercompany",
               GLCC.SEGMENT7                 "Future Use",
               RCTA.TRX_NUMBER               REFERENCE1,
               RCTTA.NAME                    REFERENCE2,
               HCA.ACCOUNT_NUMBER            REFERENCE3,
               HP.PARTY_NAME                 REFERENCE4,
               ARD.ADJUSTMENT_NUMBER         REFERENCE5,
               ARD.TYPE                      REFERENCE6,
               ARD.COMMENTS                  REFERENCE7,
               NULL                          REFERENCE8,
               NULL                          REFERENCE9,
               HRAOU.ORGANIZATION_ID,
               HRAOU.NAME                    "Oraganization Name",
               XTEU.APPLICATION_ID,
               FAT.APPLICATION_NAME          "Application Name"
          FROM APPS.GL_JE_BATCHES              GJB,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GL,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.XLA_AE_LINES               XAL,
               APPS.XLA_AE_HEADERS             XAH,
               XLA.XLA_TRANSACTION_ENTITIES#   XTEU,
               APPS.FND_APPLICATION_TL         FAT,
               APPS.AR_ADJUSTMENTS_ALL         ARD,
               APPS.RA_CUSTOMER_TRX_ALL        RCTA,
               APPS.RA_CUST_TRX_TYPES_ALL      RCTTA,
               APPS.HZ_CUST_ACCOUNTS           HCA,
               APPS.HZ_PARTIES                 HP,
               APPS.HR_ALL_ORGANIZATION_UNITS  HRAOU
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XTEU.ENTITY_ID = XAH.ENTITY_ID
               AND XTEU.ENTITY_CODE = 'ADJUSTMENTS'
               AND XTEU.APPLICATION_ID = 222
               AND XTEU.APPLICATION_ID = XAL.APPLICATION_ID
               AND XTEU.SOURCE_ID_INT_1 = ARD.ADJUSTMENT_ID
               AND XTEU.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND HRAOU.ORGANIZATION_ID = ARD.ORG_ID
               AND ARD.CUSTOMER_TRX_ID = RCTA.CUSTOMER_TRX_ID
               AND RCTA.CUST_TRX_TYPE_ID = RCTTA.CUST_TRX_TYPE_ID
               AND RCTA.ORG_ID = RCTTA.ORG_ID
               AND RCTA.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID(+)
               AND HCA.PARTY_ID = HP.PARTY_ID(+)
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME               "GL Period Name",
               GJH.CREATION_DATE             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                      "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE              "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE        "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                       "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION               "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                      AS "Batch Name",
               GJB.DESCRIPTION               "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                "Entered DR in SLA",
               XAL.ENTERED_CR                "Entered CR in SLA",
               XAL.ACCOUNTED_DR              "Accounted DR in SLA",
               XAL.ACCOUNTED_CR              "Accounted CR in SLA",
               GJL.ENTERED_DR                "Entered DR in GL",
               GJL.ENTERED_CR                "Entered CR in GL",
               GJL.ACCOUNTED_DR              "Accounted DR in GL",
               GJL.ACCOUNTED_CR              "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE     "Accounting Class",
               GLCC.SEGMENT1                 "Business Unit",
               GLCC.SEGMENT2                 "Location",
               GLCC.SEGMENT3                 "Department",
               GLCC.SEGMENT4                 "Natural Account",
               GLCC.SEGMENT5                 "Product Group",
               GLCC.SEGMENT6                 "Intercompany",
               GLCC.SEGMENT7                 "Future Use",
               ACRA.RECEIPT_NUMBER           REFERENCE1,
               ACRA.TYPE                     REFERENCE2,
               HCA.ACCOUNT_NUMBER            REFERENCE3,
               HZP.PARTY_NAME                REFERENCE4,
               NULL                          REFERENCE5,
               NULL                          REFERENCE6,
               NULL                          REFERENCE7,
               NULL                          REFERENCE8,
               NULL                          REFERENCE9,
               HRAOU.ORGANIZATION_ID,
               HRAOU.NAME                    "Oraganization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME          "Application Name"
          FROM APPS.GL_JE_BATCHES              GJB,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GL,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               APPS.GL_IMPORT_REFERENCES       GIR,
               XLA.XLA_AE_LINES                XAL,
               XLA.XLA_AE_HEADERS              XAH,
               XLA.XLA_EVENTS                  XAE,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               APPS.AR_CASH_RECEIPTS_ALL       ACRA,
               APPS.FND_APPLICATION_TL         FAT,
               APPS.HZ_CUST_ACCOUNTS           HCA,
               APPS.HZ_PARTIES                 HZP,
               APPS.HR_ALL_ORGANIZATION_UNITS  HRAOU
         WHERE     GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND UPPER (GJH.JE_SOURCE) = 'RECEIVABLES'
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.APPLICATION_ID = 222
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAH.EVENT_ID = XAE.EVENT_ID
               AND XAH.APPLICATION_ID = XAE.APPLICATION_ID
               AND XAE.ENTITY_ID = XTE.ENTITY_ID
               AND XAE.APPLICATION_ID = XTE.APPLICATION_ID
               AND XTE.ENTITY_CODE = 'RECEIPTS'
               AND XTE.SOURCE_ID_INT_1 = ACRA.CASH_RECEIPT_ID
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND ACRA.PAY_FROM_CUSTOMER = HCA.CUST_ACCOUNT_ID(+)
               AND HCA.PARTY_ID = HZP.PARTY_ID(+)
               AND ACRA.ORG_ID = HRAOU.ORGANIZATION_ID
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME               "GL Period Name",
               GJH.CREATION_DATE             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                      "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE              "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE        "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                       "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION               "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                      AS "Batch Name",
               GJB.DESCRIPTION               "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                "Entered DR in SLA",
               XAL.ENTERED_CR                "Entered CR in SLA",
               XAL.ACCOUNTED_DR              "Accounted DR in SLA",
               XAL.ACCOUNTED_CR              "Accounted CR in SLA",
               GJL.ENTERED_DR                "Entered DR in GL",
               GJL.ENTERED_CR                "Entered CR in GL",
               GJL.ACCOUNTED_DR              "Accounted DR in GL",
               GJL.ACCOUNTED_CR              "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE     "Accounting Class",
               GLCC.SEGMENT1                 "Business Unit",
               GLCC.SEGMENT2                 "Location",
               GLCC.SEGMENT3                 "Department",
               GLCC.SEGMENT4                 "Natural Account",
               GLCC.SEGMENT5                 "Product Group",
               GLCC.SEGMENT6                 "Intercompany",
               GLCC.SEGMENT7                 "Future Use",
               RCTA.TRX_NUMBER               REFERENCE1,
               RCTTA.NAME                    REFERENCE2,
               HCA.ACCOUNT_NUMBER            REFERENCE3,
               HP.PARTY_NAME                 REFERENCE4,
               NULL                          REFERENCE5,
               NULL                          REFERENCE6,
               NULL                          REFERENCE7,
               NULL                          REFERENCE8,
               NULL                          REFERENCE9,
               HRAOU.ORGANIZATION_ID,
               HRAOU.NAME                    "Oraganization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME          "Application Name"
          FROM APPS.RA_CUSTOMER_TRX_ALL        RCTA,
               APPS.RA_CUST_TRX_TYPES_ALL      RCTTA,
               APPS.HZ_CUST_ACCOUNTS           HCA,
               APPS.HZ_PARTIES                 HP,
               APPS.HR_ALL_ORGANIZATION_UNITS  HRAOU,
               APPS.FND_APPLICATION_TL         FAT,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               APPS.XLA_AE_HEADERS             XAH,
               APPS.XLA_AE_LINES               XAL,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_LEDGERS                 GL,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_JE_BATCHES              GJB,
               APPS.GL_CODE_COMBINATIONS       GLCC
         WHERE     1 = 1
               AND RCTA.CUST_TRX_TYPE_ID = RCTTA.CUST_TRX_TYPE_ID
               AND RCTA.ORG_ID = RCTTA.ORG_ID
               AND RCTA.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID(+)
               AND HCA.PARTY_ID = HP.PARTY_ID(+)
               AND HRAOU.ORGANIZATION_ID = RCTA.ORG_ID
               AND XAL.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND RCTA.CUSTOMER_TRX_ID = XTE.SOURCE_ID_INT_1
               AND XTE.ENTITY_CODE IN ('BILLS_RECEIVABLE', 'TRANSACTIONS')
               AND XTE.APPLICATION_ID = 222
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XAL.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GIR.JE_LINE_NUM = GJL.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME               "GL Period Name",
               GJH.CREATION_DATE             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                      "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE              "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE        "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                       "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION               "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                      AS "Batch Name",
               GJB.DESCRIPTION               "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                "Entered DR in SLA",
               XAL.ENTERED_CR                "Entered CR in SLA",
               XAL.ACCOUNTED_DR              "Accounted DR in SLA",
               XAL.ACCOUNTED_CR              "Accounted CR in SLA",
               GJL.ENTERED_DR                "Entered DR in GL",
               GJL.ENTERED_CR                "Entered CR in GL",
               GJL.ACCOUNTED_DR              "Accounted DR in GL",
               GJL.ACCOUNTED_CR              "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE     "Accounting Class",
               GLCC.SEGMENT1                 "Business Unit",
               GLCC.SEGMENT2                 "Location",
               GLCC.SEGMENT3                 "Department",
               GLCC.SEGMENT4                 "Natural Account",
               GLCC.SEGMENT5                 "Product Group",
               GLCC.SEGMENT6                 "Intercompany",
               GLCC.SEGMENT7                 "Future Use",
               RCTA.TRX_NUMBER               REFERENCE1,
               RCTTA.NAME                    REFERENCE2,
               HCA.ACCOUNT_NUMBER            REFERENCE3,
               HP.PARTY_NAME                 REFERENCE4,
               TO_CHAR (JLB.DOCUMENT_ID)     REFERENCE5,
               JLB.DOCUMENT_STATUS           REFERENCE6,
               NULL                          REFERENCE7,
               NULL                          REFERENCE8,
               NULL                          REFERENCE9,
               HRAOU.ORGANIZATION_ID,
               HRAOU.NAME                    "Oraganization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME          "Application Name"
          FROM APPS.JL_BR_AR_COLLECTION_DOCS_ALL  JLB,
               APPS.RA_CUSTOMER_TRX_ALL           RCTA,
               APPS.RA_CUST_TRX_TYPES_ALL         RCTTA,
               APPS.HZ_CUST_ACCOUNTS              HCA,
               APPS.HZ_PARTIES                    HP,
               APPS.HR_ALL_ORGANIZATION_UNITS     HRAOU,
               APPS.FND_APPLICATION_TL            FAT,
               XLA.XLA_TRANSACTION_ENTITIES#      XTE,
               APPS.XLA_AE_HEADERS                XAH,
               APPS.XLA_AE_LINES                  XAL,
               APPS.GL_IMPORT_REFERENCES          GIR,
               APPS.GL_JE_HEADERS                 GJH,
               APPS.GL_LEDGERS                    GL,
               APPS.GL_JE_LINES                   GJL,
               APPS.GL_JE_BATCHES                 GJB,
               APPS.GL_CODE_COMBINATIONS          GLCC
         WHERE     1 = 1
               AND JLB.CUSTOMER_TRX_ID = RCTA.CUSTOMER_TRX_ID
               AND RCTA.CUST_TRX_TYPE_ID = RCTTA.CUST_TRX_TYPE_ID
               AND RCTA.ORG_ID = RCTTA.ORG_ID
               AND RCTA.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID(+)
               AND HCA.PARTY_ID = HP.PARTY_ID(+)
               AND HRAOU.ORGANIZATION_ID = RCTA.ORG_ID
               AND JLB.DOCUMENT_ID = XTE.SOURCE_ID_INT_1
               AND XTE.ENTITY_CODE = 'JL_BR_AR_COLL_DOC_OCCS'
               AND XTE.APPLICATION_ID = 222
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAL.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAL.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GIR.JE_LINE_NUM = GJL.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               GJH.CREATION_DATE
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               RSH.RECEIPT_NUM
                   REFERENCE1,
               RCT.SOURCE_DOCUMENT_CODE
                   REFERENCE2,
               (CASE
                    WHEN RCT.SOURCE_DOCUMENT_CODE = 'PO'
                    THEN
                        (SELECT SEGMENT1
                           FROM APPS.PO_HEADERS_ALL
                          WHERE PO_HEADER_ID = RSL.PO_HEADER_ID)
                    WHEN RCT.SOURCE_DOCUMENT_CODE = 'REQ'
                    THEN
                        (SELECT SEGMENT1
                           FROM APPS.PO_REQUISITION_HEADERS_ALL  PRHA,
                                APPS.PO_REQUISITION_LINES_ALL    PRLA
                          WHERE     PRHA.REQUISITION_HEADER_ID =
                                    PRLA.REQUISITION_HEADER_ID
                                AND PRLA.REQUISITION_LINE_ID =
                                    RSL.REQUISITION_LINE_ID)
                    WHEN RCT.SOURCE_DOCUMENT_CODE = 'RMA'
                    THEN
                        (SELECT    SEGMENT1
                                || '.'
                                || SEGMENT2
                                || '.'
                                || SEGMENT3
                           FROM APPS.MTL_SALES_ORDERS
                          WHERE SALES_ORDER_ID = RSL.OE_ORDER_LINE_ID)
                    ELSE
                        NULL
                END)
                   REFERENCE3,
               (SELECT SEGMENT1
                  FROM APPS.MTL_SYSTEM_ITEMS_B
                 WHERE     INVENTORY_ITEM_ID = RSL.ITEM_ID
                       AND ORGANIZATION_ID = RCT.ORGANIZATION_ID)
                   REFERENCE4,
               HAOU.NAME
                   REFERENCE5,
               RSL.DESTINATION_TYPE_CODE
                   REFERENCE6,
               NULL
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               HAOU.ORGANIZATION_ID,
               HAOU.NAME
                   "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME
                   "Application Name"
          FROM APPS.GL_JE_BATCHES              GJB,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GL,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.XLA_AE_LINES               XAL,
               APPS.XLA_AE_HEADERS             XAH,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               APPS.RCV_TRANSACTIONS           RCT,
               APPS.RCV_SHIPMENT_HEADERS       RSH,
               APPS.RCV_SHIPMENT_LINES         RSL,
               APPS.HR_ALL_ORGANIZATION_UNITS  HAOU,
               APPS.FND_APPLICATION_TL         FAT
         WHERE     GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJB.JE_BATCH_ID = GIR.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAH.ENTITY_ID = XTE.ENTITY_ID
               AND XAH.APPLICATION_ID = XTE.APPLICATION_ID
               AND XTE.SOURCE_ID_INT_1 = RCT.TRANSACTION_ID
               AND XTE.ENTITY_CODE = 'RCV_ACCOUNTING_EVENTS'
               AND RCT.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
               AND RCT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID
               AND RCT.ORGANIZATION_ID = HAOU.ORGANIZATION_ID
               AND XAL.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               GJH.CREATION_DATE
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               TO_CHAR (WT.TRANSACTION_ID)
                   REFERENCE1,
               FLV.MEANING
                   REFERENCE2,
               WE.WIP_ENTITY_NAME
                   REFERENCE3,
               (SELECT SEGMENT1
                  FROM APPS.MTL_SYSTEM_ITEMS_B
                 WHERE     INVENTORY_ITEM_ID = WE.PRIMARY_ITEM_ID
                       AND ORGANIZATION_ID = WE.ORGANIZATION_ID)
                   REFERENCE4,
               HAOU.NAME
                   REFERENCE5,
               NULL
                   REFERENCE6,
               NULL
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               HAOU.ORGANIZATION_ID,
               HAOU.NAME
                   "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME
                   "Application Name"
          FROM APPS.GL_JE_BATCHES              GJB,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GL,
               APPS.GL_IMPORT_REFERENCES       GIR,
               XLA.XLA_AE_LINES                XAL,
               XLA.XLA_AE_HEADERS              XAH,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               WIP.WIP_TRANSACTIONS            WT,
               APPS.FND_LOOKUP_VALUES          FLV,
               WIP.WIP_ENTITIES                WE,
               APPS.HR_ALL_ORGANIZATION_UNITS  HAOU,
               APPS.FND_APPLICATION_TL         FAT
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XTE.ENTITY_CODE = 'WIP_ACCOUNTING_EVENTS'
               AND XTE.APPLICATION_ID = XAL.APPLICATION_ID
               AND XTE.APPLICATION_ID = 707
               AND XTE.SOURCE_ID_INT_1 = WT.TRANSACTION_ID
               AND WT.TRANSACTION_TYPE = FLV.LOOKUP_CODE
               AND FLV.LOOKUP_TYPE = 'WIP_TRANSACTION_TYPE'
               AND FLV.LANGUAGE = USERENV ('LANG')
               AND WT.WIP_ENTITY_ID = WE.WIP_ENTITY_ID
               AND WT.ORGANIZATION_ID = WE.ORGANIZATION_ID
               AND WT.ORGANIZATION_ID = HAOU.ORGANIZATION_ID
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               GJH.CREATION_DATE
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               TO_CHAR (MMT.TRANSACTION_ID)
                   REFERENCE1,
               MTT.TRANSACTION_TYPE_NAME
                   REFERENCE2,
               (CASE
                    WHEN MMT.TRANSACTION_TYPE_ID IN (33,
                                                     10008,
                                                     15,
                                                     62,
                                                     52,
                                                     53,
                                                     34)
                    THEN
                        (SELECT    SEGMENT1
                                || '.'
                                || SEGMENT2
                                || '.'
                                || SEGMENT3
                           FROM APPS.MTL_SALES_ORDERS
                          WHERE SALES_ORDER_ID = MMT.TRANSACTION_SOURCE_ID)
                    WHEN MMT.TRANSACTION_TYPE_ID IN (61)
                    THEN
                        (SELECT SEGMENT1
                           FROM APPS.PO_REQUISITION_HEADERS_ALL
                          WHERE REQUISITION_HEADER_ID =
                                MMT.TRANSACTION_SOURCE_ID)
                    WHEN MMT.TRANSACTION_TYPE_ID IN (18,
                                                     71,
                                                     36,
                                                     1005)
                    THEN
                        (SELECT SEGMENT1
                           FROM APPS.PO_HEADERS_ALL
                          WHERE PO_HEADER_ID = MMT.TRANSACTION_SOURCE_ID)
                    WHEN MMT.TRANSACTION_TYPE_ID IN (17,
                                                     25,
                                                     35,
                                                     38,
                                                     43,
                                                     44,
                                                     48,
                                                     55,
                                                     56,
                                                     57,
                                                     58,
                                                     90,
                                                     91,
                                                     92,
                                                     1002,
                                                     1003)
                    THEN
                        (SELECT WIP_ENTITY_NAME
                           FROM APPS.WIP_ENTITIES
                          WHERE WIP_ENTITY_ID = MMT.TRANSACTION_SOURCE_ID)
                    ELSE
                        NULL
                END)
                   REFERENCE3,
               (SELECT SEGMENT1
                  FROM APPS.MTL_SYSTEM_ITEMS_B
                 WHERE     INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID
                       AND ORGANIZATION_ID = MMT.ORGANIZATION_ID)
                   REFERENCE4,
               HRAOU.NAME
                   REFERENCE5,
               NULL
                   REFERENCE6,
               NULL
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               HRAOU.ORGANIZATION_ID,
               HRAOU.NAME
                   "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME
                   "Application Name"
          FROM APPS.XLA_AE_HEADERS             XAH,
               APPS.XLA_AE_LINES               XAL,
               APPS.XLA_EVENTS                 XAE,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GL,
               APPS.MTL_MATERIAL_TRANSACTIONS  MMT,
               APPS.HR_ALL_ORGANIZATION_UNITS  HRAOU,
               APPS.MTL_TRANSACTION_TYPES      MTT,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               APPS.GL_JE_BATCHES              GJB,
               APPS.FND_APPLICATION_TL         FAT
         WHERE     1 = 1
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAH.EVENT_ID = XAE.EVENT_ID
               AND XAH.APPLICATION_ID = XAE.APPLICATION_ID
               AND XAH.ENTITY_ID = XTE.ENTITY_ID
               AND XAE.ENTITY_ID = XTE.ENTITY_ID
               AND XAL.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAE.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GIR.JE_LINE_NUM = GJL.JE_LINE_NUM
               AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND XTE.ENTITY_CODE = 'MTL_ACCOUNTING_EVENTS'
               AND XTE.SOURCE_ID_INT_1 = MMT.TRANSACTION_ID
               AND XTE.APPLICATION_ID = 707
               AND MMT.ORGANIZATION_ID = HRAOU.ORGANIZATION_ID
               AND MMT.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME                "GL Period Name",
               GJH.CREATION_DATE              "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                       "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE               "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE         "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                        "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION                "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                       "Batch Name",
               GJB.DESCRIPTION                "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                 "Entered DR in SLA",
               XAL.ENTERED_CR                 "Entered CR in SLA",
               XAL.ACCOUNTED_DR               "Accounted DR in SLA",
               XAL.ACCOUNTED_CR               "Accounted CR in SLA",
               GJL.ENTERED_DR                 "Entered DR in GL",
               GJL.ENTERED_CR                 "Entered CR in GL",
               GJL.ACCOUNTED_DR               "Accounted DR in GL",
               GJL.ACCOUNTED_CR               "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE      "Accounting Class",
               GLCC.SEGMENT1                  "Business Unit",
               GLCC.SEGMENT2                  "Location",
               GLCC.SEGMENT3                  "Department",
               GLCC.SEGMENT4                  "Natural Account",
               GLCC.SEGMENT5                  "Product Group",
               GLCC.SEGMENT6                  "Intercompany",
               GLCC.SEGMENT7                  "Future Use",
               TO_CHAR (CWO.WRITE_OFF_ID)     REFERENCE1,
               CWO.TRANSACTION_TYPE_CODE      REFERENCE2,
               CWO.COMMENTS                   REFERENCE3,
               NULL                           REFERENCE4,
               NULL                           REFERENCE5,
               NULL                           REFERENCE6,
               NULL                           REFERENCE7,
               NULL                           REFERENCE8,
               NULL                           REFERENCE9,
               HOU.ORGANIZATION_ID            ORGANIZATION_ID,
               HOU.NAME                       "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME           "Application Name"
          FROM APPS.GL_JE_BATCHES             GJB,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_IMPORT_REFERENCES      GIR,
               XLA.XLA_AE_LINES               XAL,
               XLA.XLA_AE_HEADERS             XAH,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               XLA.XLA_TRANSACTION_ENTITIES#  XTE,
               APPS.CST_WRITE_OFFS            CWO,
               APPS.HR_OPERATING_UNITS        HOU,
               APPS.FND_APPLICATION_TL        FAT
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XTE.ENTITY_CODE = 'WO_ACCOUNTING_EVENTS'
               AND XTE.APPLICATION_ID = XAL.APPLICATION_ID
               AND XTE.APPLICATION_ID = 707
               AND XTE.SOURCE_ID_INT_1 = CWO.WRITE_OFF_ID
               AND CWO.OPERATING_UNIT_ID = HOU.ORGANIZATION_ID
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME               "GL Period Name",
               GJH.CREATION_DATE             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                      "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE              "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE        "Document Number",
               GJH.LEDGER_ID,
               GL.NAME                       "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION               "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                      "Batch Name",
               GJB.DESCRIPTION               "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                "Entered DR in SLA",
               XAL.ENTERED_CR                "Entered CR in SLA",
               XAL.ACCOUNTED_DR              "Accounted DR in SLA",
               XAL.ACCOUNTED_CR              "Accounted CR in SLA",
               GJL.ENTERED_DR                "Entered DR in GL",
               GJL.ENTERED_CR                "Entered CR in GL",
               GJL.ACCOUNTED_DR              "Accounted DR in GL",
               GJL.ACCOUNTED_CR              "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE     "Accounting Class",
               GLCC.SEGMENT1                 "Business Unit",
               GLCC.SEGMENT2                 "Location",
               GLCC.SEGMENT3                 "Department",
               GLCC.SEGMENT4                 "Natural Account",
               GLCC.SEGMENT5                 "Product Group",
               GLCC.SEGMENT6                 "Intercompany",
               GLCC.SEGMENT7                 "Future Use",
               TO_CHAR (CC.CASHFLOW_ID)      REFERENCE1,
               NULL                          REFERENCE2,
               NULL                          REFERENCE3,
               NULL                          REFERENCE4,
               NULL                          REFERENCE5,
               NULL                          REFERENCE6,
               NULL                          REFERENCE7,
               NULL                          REFERENCE8,
               NULL                          REFERENCE9,
               NULL                          ORGANIZATION_ID,
               NULL                          "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME          "Application Name"
          FROM APPS.GL_JE_BATCHES             GJB,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_IMPORT_REFERENCES      GIR,
               XLA.XLA_AE_LINES               XAL,
               XLA.XLA_AE_HEADERS             XAH,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               XLA.XLA_TRANSACTION_ENTITIES#  XTE,
               APPS.CE_CASHFLOWS              CC,
               APPS.FND_APPLICATION_TL        FAT
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XTE.ENTITY_CODE = 'CE_CASHFLOWS'
               AND XTE.APPLICATION_ID = XAL.APPLICATION_ID
               AND XTE.APPLICATION_ID = 260
               AND XTE.SOURCE_ID_INT_1 = CC.CASHFLOW_ID
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               TRUNC (GJH.CREATION_DATE)
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               FAB.ASSET_NUMBER
                   REFERENCE1,
               SUBSTR (FAT.DESCRIPTION, 1, 240)
                   REFERENCE2,
                  LTRIM (RTRIM (FCB.SEGMENT1))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT2))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT3))
                   REFERENCE3,
               FTH.BOOK_TYPE_CODE
                   REFERENCE4,
               NULL
                   REFERENCE5,
               NULL
                   REFERENCE6,
               NULL
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               NULL
                   ORGANIZATION_ID,
               NULL
                   "Organization Name",
               XTE.APPLICATION_ID,
               FATL.APPLICATION_NAME
                   "Application Name"
          FROM APPS.GL_JE_BATCHES             GJB,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               APPS.GL_IMPORT_REFERENCES      GIR,
               APPS.XLA_AE_LINES              XAL,
               APPS.XLA_AE_HEADERS            XAH,
               XLA.XLA_TRANSACTION_ENTITIES#  XTE,
               APPS.FA_TRANSACTION_HEADERS    FTH,
               APPS.FA_ADDITIONS_B            FAB,
               APPS.FA_CATEGORIES_B           FCB,
               APPS.FA_ADDITIONS_TL           FAT,
               APPS.FND_APPLICATION_TL        FATL
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJB.JE_BATCH_ID = GIR.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND FATL.LANGUAGE = USERENV ('LANG')
               AND FATL.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XTE.ENTITY_CODE = 'TRANSACTIONS'
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAH.EVENT_ID = FTH.EVENT_ID
               AND FAB.ASSET_ID = FTH.ASSET_ID
               AND FAB.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
               AND FAB.ASSET_ID = FAT.ASSET_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTE.ENTITY_CODE
                   ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               TRUNC (GJH.CREATION_DATE)
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAL.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "GL Header Name",
               GJH.CURRENCY_CODE,
               GLL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GLL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               FAB.ASSET_NUMBER
                   REFERENCE1,
               SUBSTR (FAT.DESCRIPTION, 1, 240)
                   REFERENCE2,
                  LTRIM (RTRIM (FCB.SEGMENT1))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT2))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT3))
                   REFERENCE3,
               GJL.REFERENCE_5
                   REFERENCE4,
               NULL
                   REFERENCE5,
               NULL
                   REFERENCE6,
               NULL
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               NULL
                   ORGANIZATION_ID,
               NULL
                   "Organization Name",
               FATL.APPLICATION_ID,
               FATL.APPLICATION_NAME
                   "Application Name"
          FROM APPS.GL_JE_LINES               GJL,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               APPS.GL_LEDGERS                GLL,
               APPS.GL_IMPORT_REFERENCES      GIR,
               APPS.GL_JE_BATCHES             GJB,
               APPS.XLA_AE_LINES              XAL,
               APPS.XLA_AE_HEADERS            XAH,
               XLA.XLA_TRANSACTION_ENTITIES#  XTE,
               APPS.FA_ADDITIONS_B            FAB,
               APPS.FA_ADDITIONS_TL           FAT,
               APPS.FA_CATEGORIES_B           FCB,
               APPS.FND_APPLICATION_TL        FATL
         WHERE     1 = 1
               AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.LEDGER_ID = GLL.LEDGER_ID
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAH.ENTITY_ID = XTE.ENTITY_ID
               AND XTE.ENTITY_CODE IN
                       ('DEPRECIATION', 'DEFERRED_DEPRECIATION')
               AND XTE.SOURCE_ID_INT_1 = FAB.ASSET_ID
               AND FAB.ASSET_ID = FAT.ASSET_ID
               AND FAB.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND FATL.LANGUAGE = USERENV ('LANG')
               AND FATL.APPLICATION_ID = XAL.APPLICATION_ID
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               TRUNC (GJH.CREATION_DATE)
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "JE Header Name",
               GJH.CURRENCY_CODE,
               GL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GL.NAME
                   "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   "Batch name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR
                   "Entered DR in SLA",
               XAL.ENTERED_CR
                   "Entered CR in SLA",
               XAL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               XAL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               GJL.ENTERED_DR
                   "Entered DR in GL",
               GJL.ENTERED_CR
                   "Entered CR in GL",
               GJL.ACCOUNTED_DR
                   "Accounted DR in GL",
               GJL.ACCOUNTED_CR
                   "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               FAB.ASSET_NUMBER
                   REFERENCE1,
               SUBSTR (FAT.DESCRIPTION, 1, 240)
                   REFERENCE2,
                  LTRIM (RTRIM (FCB.SEGMENT1))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT2))
               || '-'
               || LTRIM (RTRIM (FCB.SEGMENT3))
                   REFERENCE3,
               FTR.BOOK_TYPE_CODE
                   REFERENCE4,
               FAB2.ASSET_NUMBER
                   REFERENCE5,
               SUBSTR (FAT2.DESCRIPTION, 1, 240)
                   REFERENCE6,
                  LTRIM (RTRIM (FCB2.SEGMENT1))
               || '-'
               || LTRIM (RTRIM (FCB2.SEGMENT2))
               || '-'
               || LTRIM (RTRIM (FCB2.SEGMENT3))
                   REFERENCE7,
               NULL
                   REFERENCE8,
               NULL
                   REFERENCE9,
               NULL
                   ORGANIZATION_ID,
               NULL
                   "Organization Name",
               XTE.APPLICATION_ID,
               FATL.APPLICATION_NAME
                   "Application Name"
          FROM APPS.GL_JE_BATCHES             GJB,
               APPS.GL_JE_HEADERS             GJH,
               APPS.GL_JE_LINES               GJL,
               APPS.GL_LEDGERS                GL,
               APPS.GL_CODE_COMBINATIONS      GLCC,
               APPS.GL_IMPORT_REFERENCES      GIR,
               APPS.XLA_AE_LINES              XAL,
               APPS.XLA_AE_HEADERS            XAH,
               XLA.XLA_TRANSACTION_ENTITIES#  XTE,
               APPS.FA_TRX_REFERENCES         FTR,
               APPS.FA_ADDITIONS_B            FAB,
               APPS.FA_CATEGORIES_B           FCB,
               APPS.FA_ADDITIONS_TL           FAT,
               APPS.FA_ADDITIONS_B            FAB2,
               APPS.FA_CATEGORIES_B           FCB2,
               APPS.FA_ADDITIONS_TL           FAT2,
               APPS.FND_APPLICATION_TL        FATL
         WHERE     1 = 1
               AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJB.JE_BATCH_ID = GIR.JE_BATCH_ID
               AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GL.LEDGER_ID
               AND GJH.LEDGER_ID = GL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND FATL.LANGUAGE = USERENV ('LANG')
               AND FATL.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XTE.ENTITY_CODE = 'INTER_ASSET_TRANSACTIONS'
               AND XTE.ENTITY_ID = XAH.ENTITY_ID
               AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
               AND FTR.TRX_REFERENCE_ID = XTE.SOURCE_ID_INT_1
               AND FAB.ASSET_ID = FAT.ASSET_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND FAB.ASSET_ID = FTR.SRC_ASSET_ID
               AND FAB.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
               AND FAB2.ASSET_ID = FAT2.ASSET_ID
               AND FAT2.LANGUAGE = USERENV ('LANG')
               AND FAB2.ASSET_ID = FTR.DEST_ASSET_ID
               AND FAB2.ASSET_CATEGORY_ID = FCB2.CATEGORY_ID
        UNION ALL
        SELECT XTE.ENTITY_CODE,
               GJH.PERIOD_NAME                      "GL Period Name",
               TRUNC (GJH.CREATION_DATE)            "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                             "GL Header Name",
               GJH.CURRENCY_CODE,
               GLL.CURRENCY_CODE                    "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE               "Document Number",
               GJH.LEDGER_ID,
               GLL.NAME                             "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION                      "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                             "Batch Name",
               GJB.DESCRIPTION                      "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                       "Entered DR in SLA",
               XAL.ENTERED_CR                       "Entered CR in SLA",
               XAL.ACCOUNTED_DR                     "Accounted DR in SLA",
               XAL.ACCOUNTED_CR                     "Accounted CR in SLA",
               GJL.ENTERED_DR                       "Entered DR in GL",
               GJL.ENTERED_CR                       "Entered CR in GL",
               GJL.ACCOUNTED_DR                     "Accounted DR in GL",
               GJL.ACCOUNTED_CR                     "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE            "Accounting Class",
               GLCC.SEGMENT1                        "Business Unit",
               GLCC.SEGMENT2                        "Location",
               GLCC.SEGMENT3                        "Department",
               GLCC.SEGMENT4                        "Natural Account",
               GLCC.SEGMENT5                        "Product Group",
               GLCC.SEGMENT6                        "Intercompany",
               GLCC.SEGMENT7                        "Future Use",
               TO_CHAR (PDRA.DRAFT_REVENUE_NUM)     REFERENCE1,
               'PA_REVENUE'                         REFERENCE2,
               PPA.NAME                             REFERENCE3,
               PPA.SEGMENT1                         REFERENCE4,
               PPA.PROJECT_TYPE                     REFERENCE5,
               PPA.DESCRIPTION                      REFERENCE6,
               NULL                                 REFERENCE7,
               NULL                                 REFERENCE8,
               NULL                                 REFERENCE9,
               HOU.ORGANIZATION_ID,
               HOU.NAME                             "Organization Name",
               XTE.APPLICATION_ID,
               FAT.APPLICATION_NAME                 "Application Name"
          FROM APPS.XLA_AE_HEADERS             XAH,
               APPS.XLA_AE_LINES               XAL,
               APPS.XLA_EVENTS                 XAE,
               XLA.XLA_TRANSACTION_ENTITIES#   XTE,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GLL,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               APPS.GL_JE_BATCHES              GJB,
               APPS.PA_DRAFT_REVENUES_ALL      PDRA,
               APPS.PA_PROJECTS_ALL            PPA,
               APPS.HR_ALL_ORGANIZATION_UNITS  HOU,
               APPS.FND_APPLICATION_TL         FAT
         WHERE     1 = 1
               AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
               AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
               AND XAH.EVENT_ID = XAE.EVENT_ID
               AND XAH.APPLICATION_ID = XAE.APPLICATION_ID
               AND XAH.ENTITY_ID = XTE.ENTITY_ID
               AND XAE.ENTITY_ID = XTE.ENTITY_ID
               AND XAL.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAE.APPLICATION_ID = XTE.APPLICATION_ID
               AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
               AND XAL.GL_SL_LINK_TABLE = GIR.GL_SL_LINK_TABLE
               AND GIR.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GIR.JE_LINE_NUM = GJL.JE_LINE_NUM
               AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND XTE.ENTITY_CODE = 'REVENUE'
               AND XTE.SOURCE_ID_INT_1 = PDRA.PROJECT_ID
               AND XTE.SOURCE_ID_INT_2 = PDRA.DRAFT_REVENUE_NUM
               AND PPA.PROJECT_ID = PDRA.PROJECT_ID
               AND PPA.CARRYING_OUT_ORGANIZATION_ID = HOU.ORGANIZATION_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND XTE.APPLICATION_ID = 275
               AND XTE.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
        UNION ALL
        SELECT XTEU.ENTITY_CODE,
               GJH.PERIOD_NAME                       "GL Period Name",
               TRUNC (GJH.CREATION_DATE)             "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               XAH.AE_HEADER_ID,
               XAL.AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME                              "GL Header Name",
               GJH.CURRENCY_CODE,
               GLL.CURRENCY_CODE                     "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE                "Document Number",
               GJH.LEDGER_ID,
               GLL.NAME                              "Ledger Name",
               GJH.JE_CATEGORY,
               GJH.JE_SOURCE,
               GJL.DESCRIPTION                       "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME                              AS "Batch Name",
               GJB.DESCRIPTION                       "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               XAL.ENTERED_DR                        "Entered DR in SLA",
               XAL.ENTERED_CR                        "Entered CR in SLA",
               XAL.ACCOUNTED_DR                      "Accounted DR in SLA",
               XAL.ACCOUNTED_CR                      "Accounted CR in SLA",
               GJL.ENTERED_DR                        "Entered DR in GL",
               GJL.ENTERED_CR                        "Entered CR in GL",
               GJL.ACCOUNTED_DR                      "Accounted DR in GL",
               GJL.ACCOUNTED_CR                      "Accounted CR in GL",
               XAL.ACCOUNTING_CLASS_CODE             "Accounting Class",
               GLCC.SEGMENT1                         "Business Unit",
               GLCC.SEGMENT2                         "Location",
               GLCC.SEGMENT3                         "Department",
               GLCC.SEGMENT4                         "Natural Account",
               GLCC.SEGMENT5                         "Product Group",
               GLCC.SEGMENT6                         "Intercompany",
               GLCC.SEGMENT7                         "Future Use",
               TO_CHAR (PEI.EXPENDITURE_ITEM_ID)     REFERENCE1,
               TO_CHAR (PEI.EXPENDITURE_TYPE)        REFERENCE2,
               PPA.NAME                              REFERENCE3,
               PPA.SEGMENT1                          REFERENCE4,
               PPA.PROJECT_TYPE                      REFERENCE5,
               PPA.DESCRIPTION                       REFERENCE6,
               NULL                                  REFERENCE7,
               NULL                                  REFERENCE8,
               NULL                                  REFERENCE9,
               HOU.ORGANIZATION_ID,
               HOU.NAME                              "Organization Name",
               XTEU.APPLICATION_ID,
               FAT.APPLICATION_NAME                  "Application Name"
          FROM APPS.GL_JE_HEADERS              GJH,
               APPS.GL_JE_LINES                GJL,
               APPS.GL_LEDGERS                 GLL,
               APPS.GL_JE_BATCHES              GJB,
               APPS.GL_IMPORT_REFERENCES       GIR,
               APPS.XLA_AE_LINES               XAL,
               APPS.XLA_AE_HEADERS             XAH,
               APPS.GL_CODE_COMBINATIONS       GLCC,
               XLA.XLA_TRANSACTION_ENTITIES#   XTEU,
               APPS.PA_EXPENDITURE_ITEMS_ALL   PEI,
               APPS.FND_APPLICATION_TL         FAT,
               APPS.PA_PROJECTS_ALL            PPA,
               APPS.HR_ALL_ORGANIZATION_UNITS  HOU
         WHERE     1 = 1
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
               AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
               AND GJL.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.LEDGER_ID = GLL.LEDGER_ID
               AND GIR.GL_SL_LINK_ID = XAL.GL_SL_LINK_ID
               AND GIR.GL_SL_LINK_TABLE = XAL.GL_SL_LINK_TABLE
               AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
               AND XAL.APPLICATION_ID = XAH.APPLICATION_ID
               AND XAL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND XTEU.ENTITY_ID = XAH.ENTITY_ID
               AND XTEU.ENTITY_CODE = 'EXPENDITURES'
               AND XTEU.APPLICATION_ID = 275
               AND XTEU.APPLICATION_ID = XAL.APPLICATION_ID
               AND XTEU.SOURCE_ID_INT_1 = PEI.EXPENDITURE_ITEM_ID
               AND XTEU.APPLICATION_ID = FAT.APPLICATION_ID
               AND FAT.LANGUAGE = USERENV ('LANG')
               AND PEI.PROJECT_ID = PPA.PROJECT_ID
               AND PEI.ORG_ID = HOU.ORGANIZATION_ID
        UNION ALL
        SELECT NULL
                   ENTITY_CODE,
               GJH.PERIOD_NAME
                   "GL Period Name",
               TRUNC (GJH.CREATION_DATE)
                   "GL Creation Date",
               GJH.POSTED_DATE,
               GJL.EFFECTIVE_DATE,
               GJL.STATUS,
               NULL
                   AE_HEADER_ID,
               NULL
                   AE_LINE_NUM,
               GJH.JE_HEADER_ID,
               GJL.JE_LINE_NUM,
               GJH.NAME
                   "GL Header Name",
               GJH.CURRENCY_CODE,
               GLL.CURRENCY_CODE
                   "Functional Currency Code",
               GJH.DOC_SEQUENCE_VALUE
                   "Document Number",
               GJH.LEDGER_ID,
               GLL.NAME
                   "Ledger Name",
               (SELECT DISTINCT USER_JE_CATEGORY_NAME
                  FROM APPS.GL_JE_CATEGORIES_TL C
                 WHERE     C.JE_CATEGORY_NAME = GJH.JE_CATEGORY
                       AND SOURCE_LANG = 'US')
                   JE_CATEGORY,
               (SELECT DISTINCT USER_JE_SOURCE_NAME
                  FROM APPS.GL_JE_SOURCES_TL B
                 WHERE     B.JE_SOURCE_NAME = GJH.JE_SOURCE
                       AND SOURCE_LANG = 'US')
                   JE_SOURCE,
               GJL.DESCRIPTION
                   "Line Description",
               GJB.JE_BATCH_ID,
               GJB.NAME
                   AS "Batch Name",
               GJB.DESCRIPTION
                   "Batch Description",
               GJL.CREATED_BY,
               GJL.LAST_UPDATED_BY,
               GJL.CODE_COMBINATION_ID,
               GJL.ENTERED_DR
                   "Entered DR in SLA",
               GJL.ENTERED_CR
                   "Entered CR in SLA",
               GJL.ACCOUNTED_DR
                   "Accounted DR in SLA",
               GJL.ACCOUNTED_CR
                   "Accounted CR in SLA",
               NULL
                   "Entered DR in GL",
               NULL
                   "Entered CR in GL",
               NULL
                   "Accounted DR in GL",
               NULL
                   "Accounted CR in GL",
               NULL
                   "Accounting Class",
               GLCC.SEGMENT1
                   "Business Unit",
               GLCC.SEGMENT2
                   "Location",
               GLCC.SEGMENT3
                   "Department",
               GLCC.SEGMENT4
                   "Natural Account",
               GLCC.SEGMENT5
                   "Product Group",
               GLCC.SEGMENT6
                   "Intercompany",
               GLCC.SEGMENT7
                   "Future Use",
               GJL.REFERENCE_1
                   REFERENCE1,
               GJL.REFERENCE_2
                   REFERENCE2,
               GJL.REFERENCE_3
                   REFERENCE3,
               GJL.REFERENCE_4
                   REFERENCE4,
               GJL.REFERENCE_5
                   REFERENCE5,
               GJL.REFERENCE_6
                   REFERENCE6,
               GJL.REFERENCE_7
                   REFERENCE7,
               GJL.REFERENCE_8
                   REFERENCE8,
               GJL.REFERENCE_9
                   REFERENCE9,
               NULL
                   ORGANIZATION_ID,
               NULL
                   "Organization Name",
               NULL
                   APPLICATION_ID,
               NULL
                   "Application Name"
          FROM APPS.GL_JE_HEADERS         GJH,
               APPS.GL_JE_BATCHES         GJB,
               APPS.GL_JE_LINES           GJL,
               APPS.GL_LEDGERS            GLL,
               APPS.GL_CODE_COMBINATIONS  GLCC
         WHERE     1 = 1
               AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
               AND GJH.JE_BATCH_ID = GJB.JE_BATCH_ID
               AND GJL.CODE_COMBINATION_ID = GLCC.CODE_COMBINATION_ID
               AND GJL.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.LEDGER_ID = GLL.LEDGER_ID
               AND GJH.ACTUAL_FLAG = 'A'
               AND GJH.STATUS = 'P'
               AND NOT EXISTS
                       (SELECT 1
                          FROM APPS.GL_IMPORT_REFERENCES GIR
                         WHERE     GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
                               AND GIR.GL_SL_LINK_ID IS NOT NULL)) FINAL;
