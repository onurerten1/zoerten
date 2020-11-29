*----------------------------------------------------------------------*
***INCLUDE ZOE_TREE_ALV_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  save_ok = ok_code.
  CLEAR: ok_code.

  CASE save_ok.
*   WHEN .
*   WHEN .
    WHEN OTHERS.
      CALL METHOD cl_gui_cfw=>dispatch.
  ENDCASE.

  CALL METHOD cl_gui_cfw=>flush.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

  save_ok = ok_code.
  CLEAR: ok_code.

  CASE save_ok.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      CALL METHOD container->free.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
