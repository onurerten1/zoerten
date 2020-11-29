*&---------------------------------------------------------------------*
*& Report ZOE_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_dynamic_table.

PARAMETERS: p_table(10) TYPE c OBLIGATORY.

DATA: tabname TYPE tabname,
      dref    TYPE REF TO data,
      grid    TYPE REF TO cl_gui_alv_grid.

FIELD-SYMBOLS: <itab> TYPE ANY TABLE.

tabname = p_table.

CREATE DATA dref TYPE TABLE OF (tabname).

ASSIGN dref->* TO <itab>.

SELECT *
  FROM (tabname) UP TO 20 ROWS
  INTO TABLE <itab>.

CREATE OBJECT grid
  EXPORTING
    i_parent = cl_gui_container=>screen0.

CALL METHOD grid->set_table_for_first_display
  EXPORTING
    i_structure_name = tabname
  CHANGING
    it_outtab        = <itab>.

CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS0100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
*	WHEN .
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
