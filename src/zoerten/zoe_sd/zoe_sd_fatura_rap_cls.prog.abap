*&---------------------------------------------------------------------*
*& Include          ZOE_SD_FATURA_RAP_CLS
*&---------------------------------------------------------------------*
CLASS lcl_salv_ida DEFINITION FINAL.

  PUBLIC SECTION.

    DATA: lo_fullsalv_ida TYPE REF TO if_salv_gui_fullscreen_ida,
          lo_salv_ida     TYPE REF TO if_salv_gui_table_ida.

    METHODS:
      create_table IMPORTING iv_cds_table TYPE dbtabl,

      add_sel_cond IMPORTING it_vkorg TYPE ANY TABLE
                             it_vtweg TYPE ANY TABLE
                             it_vstel TYPE ANY TABLE
                             it_fkart TYPE ANY TABLE
                             it_fkdat TYPE ANY TABLE
                             it_vbeln TYPE ANY TABLE
                             it_xblnr TYPE ANY TABLE
                             it_kunrg TYPE ANY TABLE
                             it_matnr TYPE ANY TABLE
                             it_ernam TYPE ANY TABLE
                             it_erdat TYPE ANY TABLE,

      handle_hotspot
                  FOR EVENT cell_action OF if_salv_gui_field_display_opt
        IMPORTING ev_field_name
                  eo_row_data,

      button_selected
                  FOR EVENT function_selected OF if_salv_gui_toolbar_ida
        IMPORTING ev_fcode,

      change_toolbar,

      selection_mode,

      text_search,

      alv_title,

      pattern,

      hotspot_activate,

      display.

ENDCLASS.
CLASS lcl_salv_ida IMPLEMENTATION.
  METHOD create_table.

    TRY.
        lo_salv_ida = cl_salv_gui_table_ida=>create_for_cds_view( iv_cds_view_name = iv_cds_table ).
      CATCH cx_salv_db_connection
            cx_salv_db_table_not_supported
            cx_salv_ida_contract_violation
            cx_salv_function_not_supported
     INTO DATA(lx_msg).
        MESSAGE lx_msg TYPE 'I'.
    ENDTRY.

  ENDMETHOD.
  METHOD add_sel_cond.

    DATA(lo_range_collect) = NEW cl_salv_range_tab_collector( ).

    lo_range_collect->add_ranges_for_name( iv_name = 'VKORG' it_ranges = it_vkorg ).
    lo_range_collect->add_ranges_for_name( iv_name = 'VTWEG' it_ranges = it_vtweg ).
    lo_range_collect->add_ranges_for_name( iv_name = 'VSTEL' it_ranges = it_vstel ).
    lo_range_collect->add_ranges_for_name( iv_name = 'FKART' it_ranges = it_fkart ).
    lo_range_collect->add_ranges_for_name( iv_name = 'FKDAT' it_ranges = it_fkdat ).
    lo_range_collect->add_ranges_for_name( iv_name = 'VBELN' it_ranges = it_vbeln ).
    lo_range_collect->add_ranges_for_name( iv_name = 'XBLNR' it_ranges = it_xblnr ).
    lo_range_collect->add_ranges_for_name( iv_name = 'KUNRG' it_ranges = it_kunrg ).
    lo_range_collect->add_ranges_for_name( iv_name = 'MATNR' it_ranges = it_matnr ).
    lo_range_collect->add_ranges_for_name( iv_name = 'ERNAM' it_ranges = it_ernam ).
    lo_range_collect->add_ranges_for_name( iv_name = 'ERDAT' it_ranges = it_erdat ).

    lo_range_collect->get_collected_ranges(
                        IMPORTING
                          et_named_ranges = DATA(lt_sel_opt) ).

    lo_salv_ida->set_select_options( it_ranges = lt_sel_opt ).

  ENDMETHOD.
  METHOD handle_hotspot.

    DATA: ls_new TYPE zoe_sd_cds_fat_rap.

    IF ev_field_name = `MATNR`.
      TRY.
          eo_row_data->get_row_data(
                        EXPORTING
                          iv_request_type      = if_salv_gui_selection_ida=>cs_request_type-all_fields
                        IMPORTING
                          es_row               = ls_new ).
        CATCH cx_salv_ida_contract_violation
              cx_salv_ida_sel_row_deleted.
      ENDTRY.
    ENDIF.

  ENDMETHOD.
  METHOD button_selected.

    TYPES: BEGIN OF ty_new.
             INCLUDE TYPE zoe_sd_v_fat_rap.
           TYPES: END OF ty_new.

    DATA: ls_new TYPE ty_new,
          lt_new TYPE TABLE OF ty_new.

    CASE ev_fcode.
      WHEN 'VVVV'.
        DATA(lv_sel) = lo_salv_ida->selection( )->is_row_selected( ).

        IF lv_sel IS NOT INITIAL.

          lo_salv_ida->selection( )->get_selected_row(
                                      EXPORTING
                                        iv_request_type  = if_salv_gui_selection_ida=>cs_request_type-all_fields
                                      IMPORTING
                                        es_row = ls_new ).

          lo_salv_ida->selection( )->get_selected_range(
                              EXPORTING
                                iv_request_type  = if_salv_gui_selection_ida=>cs_request_type-all_fields
                              IMPORTING
                                et_selected_rows = lt_new ).

        ENDIF.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.
  METHOD change_toolbar.

    lo_salv_ida->toolbar( )->add_button( iv_fcode = 'VVVV'
                                         iv_icon  = `ICON_DISPLAY`
                                         iv_text  = `Göster` ).

    lo_salv_ida->toolbar( )->add_separator( iv_before_standard_functions = abap_true ).

  ENDMETHOD.
  METHOD selection_mode.

    lo_salv_ida->selection( )->set_selection_mode( iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-single ).

  ENDMETHOD.
  METHOD text_search.

    lo_salv_ida->standard_functions( )->set_text_search_active( iv_active = abap_true ).

    lo_salv_ida->field_catalog( )->enable_text_search( 'MATNR' ).

  ENDMETHOD.
  METHOD alv_title.

    lo_salv_ida->display_options( )->set_title( iv_title = `Fatura Raporu` ).

  ENDMETHOD.
  METHOD pattern.

    lo_salv_ida->display_options( )->enable_alternating_row_pattern( ).

  ENDMETHOD.
  METHOD display.

    lo_salv_ida->fullscreen( )->display( ).

  ENDMETHOD.
  METHOD hotspot_activate.

    TRY.
        lo_salv_ida->field_catalog( )->display_options( )->display_as_link_to_action( 'MATNR' ).
        SET HANDLER handle_hotspot FOR lo_salv_ida->field_catalog( )->display_options( ).
      CATCH cx_salv_ida_unknown_name
            cx_salv_call_after_1st_display.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
