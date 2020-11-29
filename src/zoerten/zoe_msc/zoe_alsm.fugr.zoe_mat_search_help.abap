FUNCTION zoe_mat_search_help.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCR_TAB_T
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR_T
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

  CHECK callcontrol-step = 'DISP'.

  SORT record_tab.
  DELETE ADJACENT DUPLICATES FROM record_tab.
  DATA:type_info LIKE dfies.

  callcontrol-no_maxdisp = 'X'.

  IF callcontrol-step EQ 'SELECT'.
    callcontrol-step = 'DISP'.
  ENDIF.

  CHECK: callcontrol-step EQ 'DISP'.

  CALL FUNCTION 'TABCONTROL_VISIBLE'
    EXPORTING
      visible = 'F'
      tab_id  = 1.

  SUBMIT zoe_mat_sh VIA SELECTION-SCREEN AND RETURN.
  IMPORT record_tab TO record_tab  FROM MEMORY ID 'REC1'.

  READ TABLE shlp-fielddescr INDEX 1 INTO type_info.
  type_info-leng = 18.
  CLEAR type_info-offset .
  MODIFY shlp-fielddescr INDEX 1 FROM type_info
                         TRANSPORTING leng offset.

  callcontrol-step = 'RETURN'.



ENDFUNCTION.
