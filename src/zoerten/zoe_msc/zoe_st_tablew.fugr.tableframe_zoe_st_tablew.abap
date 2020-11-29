*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZOE_ST_TABLEW
*   generation date: 09.12.2019 at 15:53:43
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZOE_ST_TABLEW      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
