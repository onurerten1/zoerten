*&---------------------------------------------------------------------*
*& Report ZOE_SALV_SET_DATA_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_salv_set_data_test.
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.
ENDCLASS.

DATA: go_table TYPE REF TO cl_salv_table,
      lt_table TYPE TABLE OF mara.

START-OF-SELECTION.
  SELECT *
    FROM mara
    INTO TABLE @lt_table
    UP TO 5 ROWS.

END-OF-SELECTION.
  PERFORM display_data.


*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .
  cl_salv_table=>factory(
                   IMPORTING
                     r_salv_table    = go_table
                   CHANGING
                     t_table         = lt_table ).

  go_table->set_screen_status(
              EXPORTING
                report        = sy-repid
                pfstatus      = 'SALV_STANDARD'
                set_functions = go_table->c_functions_all ).

  DATA(lo_handle_events) = NEW lcl_handle_events( ).
  DATA(lo_events) = go_table->get_event( ).
  SET HANDLER lo_handle_events->on_user_command FOR lo_events.

  go_table->display( ).
endform.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_SALV_FUNCTION
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm.

  CASE i_ucomm.
    WHEN 'ADD'.
      PERFORM add_additional.
      PERFORM refresh_alv.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_ADDITIONAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_additional .

  SELECT *
    FROM mara
    WHERE matnr NOT IN ( SELECT matnr
                           FROM @lt_table AS l )
    APPENDING CORRESPONDING FIELDS OF TABLE @lt_table
  UP TO 5 ROWS.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv .

  go_table->refresh( ).

ENDFORM.
