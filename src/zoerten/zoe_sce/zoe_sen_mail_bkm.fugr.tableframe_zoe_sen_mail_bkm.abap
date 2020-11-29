*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZOE_SEN_MAIL_BKM
*   generation date: 14.04.2020 at 12:05:00
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZOE_SEN_MAIL_BKM   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
