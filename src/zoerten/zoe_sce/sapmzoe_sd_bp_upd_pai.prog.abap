*&---------------------------------------------------------------------*
*& Include          SAPMZOE_SD_BP_UPD_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  ok_code = sy-ucomm.
  clear:sy-ucomm.

  CASE ok_code.
    WHEN 'NEWEN'.
      gv_int = 1.
      PERFORM new_entry.
    WHEN 'CHNG'.
      gv_int = 1.
      gv_int_cd = 1.
      gv_title = 1.
      PERFORM change.
    WHEN 'DISP'.
      gv_int = 1.
      gv_int_cd = 2.
      gv_title = 2.
      PERFORM display.
    WHEN 'CLEAR'.
      PERFORM clear.
    WHEN 'RAD'.
      PERFORM clear.
    WHEN 'SAVE'.
      PERFORM save.
    WHEN 'RPRT'.
      gv_title = 1.
      PERFORM report.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

  CLEAR gs_cust.
  CLEAR gs_vendor.
  CASE ok_code.

    WHEN 'BACK'.
      IF gv_title IS INITIAL.
        LEAVE PROGRAM.
      ENDIF.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      IF gv_title IS NOT INITIAL.
        LEAVE TO SCREEN 0.
      ELSE.
        LEAVE PROGRAM.
      ENDIF.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.

  CASE ok_code.
    WHEN 'BUT01'.
      IF p_customer = 'X'.

        SELECT SINGLE * FROM zoe_sd_bp_upd
          INTO CORRESPONDING FIELDS OF gs_cust
          WHERE cust_vend_no = gs_cust-kunnr.

        SELECT SINGLE landx FROM t005t
          INTO gs_cust_land1
          WHERE land1 = gs_cust-land1
          AND spras EQ sy-langu.

        SELECT SINGLE bezei FROM t005u
          INTO gs_cust_regio
          WHERE bland = gs_cust-regio
          AND land1 = gs_cust-land1
          AND spras EQ sy-langu.

        IF sy-subrc <> 0.
          CLEAR gs_cust-kunnr.
          MESSAGE 'No Entry Found' TYPE 'E'.
        ELSEIF sy-subrc = 0.
          CALL SCREEN '0100'.
        ENDIF.

      ELSEIF p_vendor = 'X'.

        SELECT SINGLE * FROM zoe_sd_bp_upd
          INTO CORRESPONDING FIELDS OF gs_vendor
          WHERE cust_vend_no = gs_vendor-lifnr.

        SELECT SINGLE landx FROM t005t
          INTO gs_vendor_land1
          WHERE land1 = gs_vendor_land1
          AND spras EQ sy-langu.

        SELECT SINGLE bezei FROM t005u
          INTO gs_vendor_regio
          WHERE bland = gs_vendor-regio
          AND land1 = gs_vendor-land1
          AND spras EQ sy-langu.

        IF sy-subrc <> 0.
          MESSAGE 'No Entry Found' TYPE 'E'.
        ELSEIF sy-subrc = 0.
          CALL SCREEN '0100'.
        ENDIF.

      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CLEAR save_ok.
  CASE ok_code.

    WHEN 'SAVE'.
      PERFORM save_200.
    WHEN 'DEL'.
      PERFORM deletion.
    WHEN 'NEXT'.
      PERFORM next_sl.
    WHEN 'PREV'.
      PERFORM prev_sl.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'G_TC_TAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MODIFY TABLE
MODULE g_tc_tab_modify INPUT.
  MODIFY gt_tabc
    FROM gs_tabc
    INDEX g_tc_tab-current_line.
ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'G_TC_TAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE g_tc_tab_mark INPUT.
  DATA: g_g_tc_tab_wa2 LIKE LINE OF gt_tabc.
  IF g_tc_tab-line_sel_mode = 1
  AND gs_tabc-flg = 'X'.
    LOOP AT gt_tabc INTO g_g_tc_tab_wa2
      WHERE flg = 'X'.
      g_g_tc_tab_wa2-flg = ''.
      MODIFY gt_tabc
        FROM g_g_tc_tab_wa2
        TRANSPORTING flg.
    ENDLOOP.
  ENDIF.
  MODIFY gt_tabc
    FROM gs_tabc
    INDEX g_tc_tab-current_line
    TRANSPORTING flg.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'G_TC_TAB'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE g_tc_tab_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'G_TC_TAB'
                              'GT_TABC'
                              'FLG'
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.
