*&---------------------------------------------------------------------*
*& Include          ZOE_SEN01_REV_CLS
*&---------------------------------------------------------------------*
CLASS gcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.
CLASS gcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.
ENDCLASS.
