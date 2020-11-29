*&---------------------------------------------------------------------*
*& Include          ZOE_MM_MALZ_GRNM_BKM_CLS
*&---------------------------------------------------------------------*
CLASS lcl_events DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: hotspot FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column.
ENDCLASS.
CLASS lcl_events IMPLEMENTATION.
  METHOD hotspot.
    PERFORM hotspot USING row column.
  ENDMETHOD.
ENDCLASS.
