*&---------------------------------------------------------------------*
*& Include          SAPMZOE_SD_BP_UPD_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  IF gt_ucomm IS INITIAL.
    gs_ucomm = 'SAVE'. APPEND gs_ucomm TO gt_ucomm.
    gs_ucomm = 'CLEAR'. APPEND gs_ucomm TO gt_ucomm.
  ELSEIF gt_ucomm IS NOT INITIAL AND sy-ucomm EQ 'BUT01'.
    gs_ucomm = 'SAVE'. APPEND gs_ucomm TO gt_ucomm.
    gs_ucomm = 'RPRT'. APPEND gs_ucomm TO gt_ucomm.
  ELSEIF gt_ucomm IS NOT INITIAL AND sy-ucomm EQ 'BUT02'.
    gs_ucomm = 'RPRT'. APPEND gs_ucomm TO gt_ucomm.
  ENDIF.
  SET PF-STATUS 'STATUS100' EXCLUDING gt_ucomm.
  SET TITLEBAR 'TITLE01'.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        IF gv_int = 0.
          screen-input = 0.
          screen-invisible = 1.
        ELSEIF gv_int NE 0 AND p_vendor = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
        IF gs_cust-kunnr IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-NAME1'.
        ENDIF.
        IF gs_cust-name1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-NAME2'.
        ENDIF.
        IF gs_cust-name2 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-LAND1'.
        ENDIF.
        IF gs_cust-land1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-REGIO'.
        ENDIF.
        IF gs_cust-regio IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-TELF1'.
        ENDIF.
        IF gs_cust-telf1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_CUST-ADRNR'.
        ENDIF.
      WHEN 'GR2'.
        IF gv_int = 0.
          screen-input = 0.
          screen-invisible = 1.
        ELSEIF gv_int NE 0 AND p_customer = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
        IF gs_vendor-lifnr IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-NAME1'.
        ENDIF.
        IF gs_vendor-name1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-NAME2'.
        ENDIF.
        IF gs_vendor-name2 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-LAND1'.
        ENDIF.
        IF gs_vendor-land1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-REGIO'.
        ENDIF.
        IF gs_vendor-regio IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-TELF1'.
        ENDIF.
        IF gs_vendor-telf1 IS NOT INITIAL.
          SET CURSOR FIELD 'GS_VENDOR-ADRNR'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

  LOOP AT SCREEN.
    IF gv_title = 1.
      CASE screen-group3.
        WHEN 'GR1' OR 'GR2'.
          screen-input = 0.
        WHEN OTHERS.
      ENDCASE.
    ELSEIF gv_title = 2.
      CASE screen-group2.
        WHEN 'GR1' OR 'GR2'.
          screen-input = 0.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  CLEAR ok_code.
  CLEAR gv_int_cd.
  CLEAR gv_title.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.

  SET PF-STATUS 'STATUS110'.

  IF gv_title = 1.
    SET TITLEBAR 'TITLE02'.
  ELSEIF gv_title = 2.
    SET TITLEBAR 'TITLE03'.
  ENDIF.

  IF gv_int_cd = 1.
    but01 = TEXT-b01.
  ELSEIF gv_int_cd = 2.
    but01 = TEXT-b02.
  ENDIF.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GRA'.
        IF p_vendor = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN 'GRB'.
        IF p_customer = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
  CLEAR gs_cust-kunnr.
  CLEAR gs_vendor-lifnr.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'STATUS200'.
  SET TITLEBAR 'TITLE04'.

ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'G_TC_TAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE g_tc_tab_change_tc_attr OUTPUT.
  DESCRIBE TABLE gt_tabc LINES g_tc_tab-lines.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'G_TC_TAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE g_tc_tab_get_lines OUTPUT.
  g_g_tc_tab_lines = sy-loopc.
ENDMODULE.
