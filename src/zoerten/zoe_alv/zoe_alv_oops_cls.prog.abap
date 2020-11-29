*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_OOPS_CLS
*&---------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
            e_row
            e_column
            es_row_no,
      handle_double_click2 FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
            e_row
            e_column
            es_row_no.
ENDCLASS.

CLASS lcl_eventhandler IMPLEMENTATION.

  METHOD handle_double_click.
    PERFORM alv USING es_row_no-row_id.
  ENDMETHOD.
  METHOD handle_double_click2.
    PERFORM transaction USING es_row_no-row_id.
  ENDMETHOD.

ENDCLASS.
