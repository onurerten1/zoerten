*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 10.04.2020 at 15:41:41
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZOE_V003........................................*
FORM GET_DATA_ZOE_V003.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZOE_T003 WHERE
(VIM_WHERETAB) .
    CLEAR ZOE_V003 .
ZOE_V003-MANDT =
ZOE_T003-MANDT .
ZOE_V003-BUKRS =
ZOE_T003-BUKRS .
ZOE_V003-IBAN =
ZOE_T003-IBAN .
ZOE_V003-DATUM =
ZOE_T003-DATUM .
ZOE_V003-UZEIT =
ZOE_T003-UZEIT .
<VIM_TOTAL_STRUC> = ZOE_V003.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZOE_V003 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZOE_V003.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZOE_V003-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZOE_T003 WHERE
  BUKRS = ZOE_V003-BUKRS .
    IF SY-SUBRC = 0.
    DELETE ZOE_T003 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZOE_T003 WHERE
  BUKRS = ZOE_V003-BUKRS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZOE_T003.
    ENDIF.
ZOE_T003-MANDT =
ZOE_V003-MANDT .
ZOE_T003-BUKRS =
ZOE_V003-BUKRS .
ZOE_T003-IBAN =
ZOE_V003-IBAN .
ZOE_T003-DATUM =
ZOE_V003-DATUM .
ZOE_T003-UZEIT =
ZOE_V003-UZEIT .
    IF SY-SUBRC = 0.
    UPDATE ZOE_T003 ##WARN_OK.
    ELSE.
    INSERT ZOE_T003 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZOE_V003-UPD_FLAG,
STATUS_ZOE_V003-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZOE_V003.
  SELECT SINGLE * FROM ZOE_T003 WHERE
BUKRS = ZOE_V003-BUKRS .
ZOE_V003-MANDT =
ZOE_T003-MANDT .
ZOE_V003-BUKRS =
ZOE_T003-BUKRS .
ZOE_V003-IBAN =
ZOE_T003-IBAN .
ZOE_V003-DATUM =
ZOE_T003-DATUM .
ZOE_V003-UZEIT =
ZOE_T003-UZEIT .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZOE_V003 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZOE_V003-BUKRS TO
ZOE_T003-BUKRS .
MOVE ZOE_V003-MANDT TO
ZOE_T003-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZOE_T003'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZOE_T003 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZOE_T003'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*