*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_DENEME_SEN_CLS
*&---------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column
          es_row_no,
      hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_column_id
          e_row_id
          es_row_no,
      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      handle_user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.
CLASS lcl_eventhandler IMPLEMENTATION.
  METHOD double_click.
    PERFORM double_click USING es_row_no-row_id.
  ENDMETHOD.
  METHOD hotspot.
    PERFORM hotspot USING e_column_id e_row_id.
  ENDMETHOD.
  METHOD handle_toolbar.
    PERFORM handle_toolbar USING e_object.
  ENDMETHOD.
  METHOD handle_user_command.
    PERFORM handle_user_command USING e_ucomm.
  ENDMETHOD.
ENDCLASS.
