*&---------------------------------------------------------------------*
*& Include          ZOE_STEP_LOOP_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BCNT'.
      CLEAR: gs_0100-text01,
             gs_0100-text02.
      PERFORM check_vstel.
      PERFORM check_wadat.
    WHEN 'BSRC'.
      CLEAR: gs_0100-text01.
      PERFORM clear_steploop.
      CALL SCREEN 0101.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      IF gv_status = '0100'.
        LEAVE PROGRAM.
      ELSEIF gv_status = '0101'.
        CLEAR: gs_0100-text01,
               gs_0100-text02.
        SET SCREEN 0100.
      ELSEIF gv_status = '0200'.
        SET SCREEN 0100.
      ELSEIF gv_status = '0300'.
        PERFORM clear_steploop.
        SET SCREEN 0200.
      ENDIF.
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  save_ok = ok_code.
  PERFORM button_click USING save_ok.

  CASE save_ok.
    WHEN 'CHK'.
      LOOP AT itab INTO wa.
        IF wa-p_chk = 'X'.
          gs_0100-vstel = wa-vstel.
          CLEAR: gs_0100-text01.
          PERFORM clear_steploop.
          SET SCREEN 0100.
          RETURN.
        ENDIF.
      ENDLOOP.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  save_ok = ok_code.
  PERFORM button_click USING save_ok.

  CASE save_ok.
    WHEN 'DETAY'.
      PERFORM clear_steploop.
      CALL SCREEN 0300.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANSP_ITAB_IN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE transp_itab_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY itab FROM wa INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANSP_ITAB_IN2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE transp_itab_in2 INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY itab2 FROM wa2 INDEX idx.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  save_ok = ok_code.
  PERFORM button_click USING save_ok.

  CASE save_ok.
    WHEN 'MAL'.
      PERFORM call_bapi.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANSP_ITAB_IN3  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE transp_itab_in3 INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY itab3 FROM wa3 INDEX idx.
ENDMODULE.
