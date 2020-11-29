*&---------------------------------------------------------------------*
*& Modulpool SAPMZOE_CONTEXT_MENU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzoe_context_menu.
DATA text1(10) TYPE c.
DATA text2(10) TYPE c.
DATA text_cut(10) TYPE c.
DATA right_clk TYPE REF TO cl_ctmenu.
DATA ok_code TYPE sy-ucomm.
DATA:prog    TYPE sy-repid,
     flag(1) TYPE c VALUE 'X',
     fld(20) TYPE c,
     off     TYPE i,
     val(20) TYPE c.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  prog = sy-repid.
* SET PF-STATUS 'ZGUI_9000'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.                 " STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  CLEAR ok_code.
  ok_code = sy-ucomm.
  CASE ok_code.
    WHEN 'OPEN'.
      MESSAGE 'OPEN IS CLICKED' TYPE 'I'.
    WHEN 'CUT'.
      text_cut = text1. "storing in some temp variable
      CLEAR text1.
    WHEN 'PASTE'.
      GET CURSOR FIELD fld VALUE val."to find out in which i/o field the cursor is in
      IF fld = 'TEXT2'.
        text2 = text_cut.
      ELSEIF fld = 'TEXT1'.
        text1 = text_cut.
      ENDIF.
    WHEN 'CLEAR'.
      CLEAR : text1 ,text2,text_cut.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9000  INPUT
"RIGHT CLICK on text 1 input/ouput field
FORM on_ctmenu_text1 USING l_menu TYPE REF TO cl_ctmenu.
  CREATE OBJECT right_clk.
  CALL METHOD: right_clk->add_function
                      EXPORTING fcode = 'OPEN'
                                text  = 'Open',
               right_clk->add_function
                       EXPORTING fcode = 'CUT'
                                 text  = 'Cut',
               right_clk->add_function
                       EXPORTING fcode = 'PASTE'
                                 text  = 'Paste',
              right_clk->add_function
                       EXPORTING fcode = 'MOVE'
                                 text  = 'Move',
               l_menu->add_submenu
                       EXPORTING menu = right_clk
                                 text = 'OPTIONS'.
ENDFORM.
"RIGHT CLICK on text 2 input/ouput field
FORM on_ctmenu_text2 USING l_menu TYPE REF TO cl_ctmenu.
  CREATE OBJECT right_clk.
  CALL METHOD: right_clk->add_function
                      EXPORTING fcode = 'OPEN'
                                text  = 'Open',
               right_clk->add_function
                       EXPORTING fcode = 'CUT'
                                 text  = 'Cut',
               right_clk->add_function
                       EXPORTING fcode = 'PASTE'
                                 text  = 'Paste',
              right_clk->add_function
                       EXPORTING fcode = 'MOVE'
                                 text  = 'Move',
               l_menu->add_submenu
                       EXPORTING menu = right_clk
                                 text = 'OPTIONS'.
ENDFORM.
