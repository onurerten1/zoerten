*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_OOPS_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: rs_selfield TYPE slis_selfield.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'SEND'.
      PERFORM show_popup.
  ENDCASE.


ENDMODULE.
