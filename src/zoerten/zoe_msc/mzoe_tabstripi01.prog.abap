*&---------------------------------------------------------------------*
*& Include MZOE_TABSTRIPI01
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TS 'TABSTRIP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE TABSTRIP_ACTIVE_TAB_GET INPUT.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN C_TABSTRIP-TAB1.
      G_TABSTRIP-PRESSED_TAB = C_TABSTRIP-TAB1.
    WHEN C_TABSTRIP-TAB2.
      G_TABSTRIP-PRESSED_TAB = C_TABSTRIP-TAB2.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.

ENDMODULE.
