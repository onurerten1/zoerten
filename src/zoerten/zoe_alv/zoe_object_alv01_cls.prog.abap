*&---------------------------------------------------------------------*
*& Include          ZOE_OBJECT_ALV01_CLS
*&---------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_hotspot_click
            FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
            es_row_no.
ENDCLASS.
CLASS lcl_eventhandler IMPLEMENTATION.
    METHOD on_hotspot_click.
      PERFORM hotspot USING es_row_no-row_id.
    ENDMETHOD.
ENDCLASS.
