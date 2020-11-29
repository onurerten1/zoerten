*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FAT_RAP_F01
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

  DATA: lv_where TYPE string.

  IF p_chk IS INITIAL.
  ELSE.
    lv_where = |z~fksto NE 'X' AND z~sfakn EQ ' '|.
  ENDIF.


  SELECT *
    FROM zoe_sd_cds_fat_rap AS z
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE z~vkorg IN @so_vkorg
    AND   z~vtweg IN @so_vtweg
    AND   z~fkart IN @so_fkart
    AND   z~fkdat IN @so_fkdat
    AND   z~vbeln IN @so_vbeln
    AND   z~xblnr IN @so_xblnr
    AND   z~kunrg IN @so_kunrg
    AND   z~matnr IN @so_matnr
    AND   z~ernam IN @so_ernam
    AND   z~erdat IN @so_erdat
    AND   z~vstel IN @so_vstel
    AND   (lv_where)
    ORDER BY vbeln, posnr.

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
    TRY.
        cl_salv_table=>factory( IMPORTING
                                    r_salv_table = go_alv
                                CHANGING
                                    t_table = gt_data ).
      CATCH cx_salv_msg INTO DATA(lx_salv_msg).
        MESSAGE lx_salv_msg TYPE 'E'.
        LEAVE LIST-PROCESSING.
    ENDTRY.

    PERFORM set_functions.

    PERFORM set_columns.

    PERFORM set_selections.

    PERFORM set_display.

    IF p_sub = abap_true.
      PERFORM set_subtotals.
    ENDIF.

  ENDIF.

  go_alv->display( ).

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

  lo_functions = go_alv->get_functions( ).
  lo_functions->set_all( if_salv_c_bool_sap=>true ).

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
        lo_column  TYPE REF TO cl_salv_column_table.

  lo_columns = go_alv->get_columns( ).
  lo_columns->set_optimize( 'X' ).

  TRY.
      lo_column ?= lo_columns->get_column( 'VBELN' ).
      lo_column->set_key( 'X' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lo_column ?= lo_columns->get_column( 'POSNR' ).
      lo_column->set_key( 'X' ).
    CATCH cx_salv_not_found.
  ENDTRY.

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

  lo_selections = go_alv->get_selections( ).
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

  DATA: lo_display_settings TYPE REF TO cl_salv_display_settings.

  lo_display_settings = go_alv->get_display_settings( ).
  lo_display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SUBTOTALS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_subtotals.

  DATA: lo_aggregations TYPE REF TO cl_salv_aggregations,
        lo_sorts        TYPE REF TO cl_salv_sorts.

  lo_aggregations = go_alv->get_aggregations( ).
  lo_aggregations->clear( ).
  lo_sorts = go_alv->get_sorts( ).
  lo_sorts->clear( ).

  TRY.
      lo_sorts->add_sort( columnname = 'WAERK'
                          subtotal   = if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
    CATCH cx_salv_data_error.
  ENDTRY.

  TRY.
      lo_aggregations->add_aggregation( 'NETWR' ).
    CATCH cx_salv_data_error.
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
  ENDTRY.

  TRY.
      lo_aggregations->add_aggregation( 'TOPTT' ).
    CATCH cx_salv_data_error.
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
  ENDTRY.

  TRY.
      lo_aggregations->add_aggregation( 'TRYNF' ).
    CATCH cx_salv_data_error.
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
  ENDTRY.

  TRY.
      lo_aggregations->add_aggregation( 'TRYTT' ).
    CATCH cx_salv_data_error.
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
  ENDTRY.

ENDFORM.
