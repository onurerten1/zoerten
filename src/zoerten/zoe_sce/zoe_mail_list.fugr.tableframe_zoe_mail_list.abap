*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZOE_MAIL_LIST
*   generation date: 30.04.2020 at 12:56:38
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZOE_MAIL_LIST      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
