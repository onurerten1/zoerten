*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZOE_SD_MT
*   generation date: 30.09.2019 at 16:58:11
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZOE_SD_MT          .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
