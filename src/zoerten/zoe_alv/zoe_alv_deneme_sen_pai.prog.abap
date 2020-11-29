*----------------------------------------------------------------------*
***INCLUDE ZOE_ALV_DENEME_SEN_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

*  ok_code = sy-ucomm.
*  CLEAR: sy-ucomm.
*
*  CASE ok_code.
*    WHEN 'YAZDIR'.
*      PERFORM print_items.
**    WHEN .
*    WHEN OTHERS.
*  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

  ok_code = sy-ucomm.
  CLEAR: sy-ucomm.

  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
