*&---------------------------------------------------------------------*
*& Report ZOE_CDS_FAT_RAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_fat_rap.

DATA: gr_table   TYPE REF TO cl_salv_table,
      gr_display TYPE REF TO cl_salv_display_settings,
      gr_select  TYPE REF TO cl_salv_selections.

DATA: gt_fat_rap LIKE TABLE OF zoe_cds_fat_rap2.

PERFORM case1.

*PERFORM case2.
*&---------------------------------------------------------------------*
*& Form MODIFY_COLUMNS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_columns .

  DATA: lt_dfies      TYPE ddfields,
        ls_dfies      TYPE dfies,
        lo_typedescr  TYPE REF TO cl_abap_typedescr,
        lo_strucdescr TYPE REF TO cl_abap_structdescr,
        lo_tabledescr TYPE REF TO cl_abap_tabledescr,
        lo_columns    TYPE REF TO cl_salv_columns_table,
        lo_column     TYPE REF TO cl_salv_column.

  DATA: lv_name TYPE ddfieldname_l.

  lo_columns = gr_table->get_columns( ).

  lo_typedescr = cl_abap_typedescr=>describe_by_data( gt_fat_rap ).
  lo_tabledescr ?= lo_typedescr.
  lo_strucdescr ?= lo_tabledescr->get_table_line_type( ).

  lt_dfies = lo_strucdescr->get_ddic_field_list( ).

  LOOP AT lt_dfies INTO ls_dfies.

    CLEAR: lv_name.

    lo_column = lo_columns->get_column( ls_dfies-fieldname ).

    CASE ls_dfies-fieldname.
      WHEN 'MANDT'.
        lo_column->set_visible( value = if_salv_c_bool_sap=>false ).
      WHEN 'BRMFY'.
        lv_name = 'BRMFY'.
      WHEN 'TOPTT'.
        lv_name = 'TOPTT'.
      WHEN 'TRYNF'.
        lv_name = 'TRYNF'..
      WHEN 'TRYVR'.
        lv_name = 'TRYVR'.
      WHEN 'TRYBF'.
        lv_name = 'TRYBF'.
      WHEN 'TRYTT'.
        lv_name = 'TRYTT'.
      WHEN 'NAME1'.
        lv_name = 'NAME1'.
      WHEN 'NAME11'.
        lv_name = 'NAME11'.
      WHEN 'TEXT1'.
        lv_name = 'TEXT1'.
      WHEN OTHERS.
    ENDCASE.

    IF lv_name IS NOT INITIAL.
      DATA(lv_label) =  cl_dd_ddl_annotation_service=>get_label_4_element(
             entityname = 'ZOE_CDS_FATURA2'
             elementname = lv_name
             language = sy-langu ).
      DATA(lv_qinfo) = cl_dd_ddl_annotation_service=>get_quickinfo_4_element(
                      entityname = 'ZOE_CDS_FATURA2'
                      elementname = lv_name
                      language = sy-langu ).
      lo_column->set_short_text( value = lv_label(10) ).
      lo_column->set_medium_text( value = lv_label(20) ).
      lo_column->set_long_text( value = lv_label(40) ).
      lo_column->set_tooltip( value = lv_qinfo(40) ).
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CASE1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM case1 .
  SELECT *
    FROM zoe_cds_fat_rap2
    INTO TABLE @gt_fat_rap.

  IF gt_fat_rap IS NOT INITIAL.
    cl_salv_table=>factory(
    IMPORTING r_salv_table = gr_table
      CHANGING t_table = gt_fat_rap ).

    PERFORM modify_columns.

    gr_display = gr_table->get_display_settings( ).
    gr_display->set_fit_column_to_table_size( value = if_salv_c_bool_sap=>true ).
    gr_display->set_striped_pattern( value = if_salv_c_bool_sap=>true ).
    gr_display->set_list_header( value = 'Fatura Raporu' ).

    gr_select = gr_table->get_selections( ).
    gr_select->set_selection_mode( value = if_salv_c_selection_mode=>row_column ).

    gr_table->display( ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CASE2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM case2 .
  DATA: lr_cds_tab TYPE REF TO if_salv_gui_table_ida,
        lr_fcat    TYPE REF TO if_salv_gui_field_catalog_ida,
        lr_disp    TYPE REF TO if_salv_gui_table_display_opt,
        lr_toolbar TYPE REF TO if_salv_gui_toolbar_ida,
        lr_select  TYPE REF TO if_salv_gui_selection_ida.

*  cl_salv_gui_table_ida=>create_for_cds_view( 'ZOE_CDS_FATURA2' )->fullscreen( )->display( ).
  lr_cds_tab = cl_salv_gui_table_ida=>create_for_cds_view( 'ZOE_CDS_FATURA2' ).

  DATA: lt_fnames TYPE if_salv_gui_types_ida=>yts_field_name.

  lr_fcat = lr_cds_tab->field_catalog( ).
  CALL METHOD lr_fcat->get_available_fields
    IMPORTING
      ets_field_names = lt_fnames.
  IF lt_fnames IS NOT INITIAL.
    DELETE lt_fnames WHERE table_line = 'MANDT'.
  ENDIF.
  CALL METHOD lr_fcat->set_available_fields
    EXPORTING
      its_field_names = lt_fnames.
  DELETE lt_fnames WHERE table_line NE 'VBELN' OR table_line NE 'POSNR'.
  CALL METHOD lr_fcat->set_unique_row_key
    EXPORTING
      its_field_names = lt_fnames.


  lr_disp = lr_cds_tab->display_options( ).
  lr_disp->enable_alternating_row_pattern( ).

  lr_toolbar = lr_cds_tab->toolbar( ).
  lr_toolbar->add_button(
    EXPORTING
      iv_fcode                     = 'FC01'
      iv_icon                      = icon_generate
      iv_text                      = 'Test'
      iv_quickinfo                 = 'Test quickinfo' ).

  lr_select = lr_cds_tab->selection( ).
  lr_select->set_selection_mode(
      iv_mode = 'MULTI'
  ).
*  CATCH cx_salv_ida_contract_violation. " IDA API contract violated by caller
*  CATCH cx_salv_ida_contract_violation. " IDA API contract violated by caller

  DATA(disp) = lr_cds_tab->fullscreen( ).
  disp->display( ).
ENDFORM.
