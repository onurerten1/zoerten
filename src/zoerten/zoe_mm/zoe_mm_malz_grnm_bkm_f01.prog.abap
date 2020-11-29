*&---------------------------------------------------------------------*
*& Include          ZOE_MM_MALZ_GRNM_BKM_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data.

  SELECT *
    FROM zoe_mm_cds_malz_grn_bkm
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE matnr IN @so_matnr
    AND   werks IN @so_werks
    AND   vkorg IN @so_vkorg
    AND   vtweg IN @so_vtweg
    AND   matkl IN @so_matkl
    AND   mtart IN @so_mtart
    ORDER BY matnr, werks.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data.

  IF gt_data[] IS NOT INITIAL.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM hotspot  USING    pv_row TYPE salv_de_row
                       pv_column TYPE salv_de_column.

  READ TABLE gt_data INTO gs_data INDEX pv_row.
  IF sy-subrc = 0.
    SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
    CALL TRANSACTION 'MM03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_0100.
  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR 'TITLE0100'.
  PERFORM create_alv.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form EXIT_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exit_command.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_alv.

  IF container IS NOT BOUND.

    IF cl_salv_table=>is_offline( ) EQ if_salv_c_bool_sap=>false.

      container = NEW #( container_name = 'CONTAINER' ).

    ENDIF.

    TRY.
        cl_salv_table=>factory( EXPORTING
                                    r_container = container
                                    container_name = 'CONTAINER'
                                IMPORTING
                                    r_salv_table = gr_alv
                                CHANGING
                                    t_table = gt_data ).
      CATCH cx_salv_msg INTO gv_salv_msg.
        MESSAGE gv_salv_msg TYPE 'E'.
        LEAVE LIST-PROCESSING.
    ENDTRY.

    PERFORM set_functions.

    PERFORM set_columns.

    PERFORM set_events.

    PERFORM set_selections.

    PERFORM set_display.

  ENDIF.

  gr_alv->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_COLUMNS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_columns.

  DATA: lo_columns TYPE REF TO cl_salv_columns_table,
        lo_column  TYPE REF TO cl_salv_column_table,
        lv_index   TYPE lvc_fname.

  lo_columns = gr_alv->get_columns( ).
  lo_columns->set_optimize( 'X' ).

  DO 15 TIMES.
    lv_index = 'GRNM' && sy-index.
    TRY.
        lo_column ?= lo_columns->get_column( lv_index ).
        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDDO.

  TRY.
      lo_column ?= lo_columns->get_column( 'MATNR' ).
      lo_column->set_key( 'X' ).
      lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_events.

  DATA: lo_events TYPE REF TO cl_salv_events_table.

  lo_events = gr_alv->get_event( ).

  gr_events = NEW #( ).

  SET HANDLER gr_events->hotspot FOR lo_events.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FUNCTIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_functions.

  DATA: lo_functions TYPE REF TO cl_salv_functions_list.

  lo_functions = gr_alv->get_functions( ).
  lo_functions->set_all( if_salv_c_bool_sap=>true ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SELECTIONS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_selections.

  DATA: lo_selections TYPE REF TO cl_salv_selections.

  lo_selections = gr_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>cell ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_display.

  DATA: lo_display_settings TYPE REF TO cl_salv_display_settings,
        lv_title            TYPE lvc_title.

  lv_title = TEXT-t01.
  lo_display_settings = gr_alv->get_display_settings( ).
  lo_display_settings->set_list_header( lv_title ).
  lo_display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).

ENDFORM.
