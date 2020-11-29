*&---------------------------------------------------------------------*
*& Include          ZOE_SALV_PATTERN_CLS
*&---------------------------------------------------------------------*
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function,

      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column,

      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column.
ENDCLASS.
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.

  METHOD on_double_click.
    PERFORM handle_double_click USING row
                                      column.
  ENDMETHOD.

  METHOD on_link_click.
    PERFORM handle_link_click USING row
                                    column.
  ENDMETHOD.
ENDCLASS.
